import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NotifierService } from 'angular-notifier';
import { LicenseService } from '../../license.service';
import { MyIpcService } from '../../my-ipc.service';

@Component({
  selector: 'app-initial-setup',
  templateUrl: './initial-setup.component.html',
  styleUrls: ['./initial-setup.component.scss']
})
export class InitialSetupComponent implements OnInit {

  mForm: FormGroup;
  camForm: FormGroup;

  server: string;
  port: string;
  dbName: string;
  username: string;
  password: string;

  camPictureUrl: string;
  camUser: string;
  camPassword: string;

  isLicenseActive: boolean = false;
  licenseNumber: string;

  validTill: string;

  constructor(
    private notifier: NotifierService,
    private fb: FormBuilder,
    private ipcService: MyIpcService,
    private licenseService: LicenseService
  ) { }

  ngOnInit() {
    this.mForm = this.fb.group({
      inputDbName: ['', Validators.required],
      inputServer: ['', Validators.required],
      inputPort: ['1433', Validators.required],
      inputUsername: ['', Validators.required],
      inputPassword: ['', Validators.required]
    });

    this.camForm = this.fb.group({
      inputPicUrl: [''],
      inputCamUsername: [''],
      inputCamPassword: ['']
    });

    this.ipcService.invokeIPC("loadEnvironmentVars", ["database"]).then(result => {
      this.server = result['server'];
      this.dbName = result['database'];
      this.username = result['username'];
      this.password = result['password'];
      this.port = result['port'] ? result['port']:1433;
    });

    this.ipcService.invokeIPC("loadEnvironmentVars", ["camera"]).then(result => {
      this.camUser = result['user'];
      this.camPassword = result['password'];
      this.camPictureUrl = result['pictureUrl'];
    });

    this.getLicenseDetails();
  }

  getLicenseDetails() {
    this.licenseService.getLicenseDetails().then(async (result) => {
      if (result && result !== null) {
        this.licenseNumber = result['license_key'] || '';
        if (result['expiry_date']) {
          var expDate = new Date(result['expiry_date']);
          this.validTill = `${expDate.getDate()}/${expDate.getMonth() + 1}/${expDate.getFullYear()}`;
        }
        var licenseStatus = await this.licenseService.validateLicenseDetail(result);
        this.isLicenseActive = licenseStatus['success'];
        if (!this.isLicenseActive) {
          this.validTill = licenseStatus['msg'];
        }
      } else {
        this.isLicenseActive = false;
      }
    });
  }

  formatLicenseNumber(licenseNumber) {
    let temp = [];

    temp.push(licenseNumber.substr(0, 4));

    if (licenseNumber.substr(4, 4) !== "")
      temp.push(licenseNumber.substr(4, 4));

    if (licenseNumber.substr(8, 4) != "")
      temp.push(licenseNumber.substr(8, 4));

    if (licenseNumber.substr(12, 4) != "")
      temp.push(licenseNumber.substr(12, 4));
    if (licenseNumber.substr(16, 4) != "")
      temp.push(licenseNumber.substr(16, 4));
    if (licenseNumber.substr(20, 4) != "")
      temp.push(licenseNumber.substr(20, 4));

    return temp.join('-');
  }

  saveCameraSettings() {
    this.ipcService.invokeIPC("saveSingleEnvVar", ["camera", {
      "user": this.camUser,
      "pictureUrl": this.camPictureUrl,
      "password": this.camPassword
    }]).then(res => {
      if (res) {
        this.notifier.notify("success", "Save successful");
      } else {
        this.notifier.notify("error", "Failed to save");
      }
    });
  }

  save() {
    this.ipcService.invokeIPC("saveSingleEnvVar", ["database", {
      "server": this.server,
      "database": this.dbName,
      "username": this.username,
      "password": this.password,
      "port": this.port
    }]).then(res => {
      if (res) {
        this.ipcService.invokeIPC("initializeDBConfig", [{
          "database": {
            "server": this.server,
            "database": this.dbName,
            "username": this.username,
            "password": this.password,
            "port": this.port
          }
        }]);
        this.notifier.notify("success", "Save successful");
      } else {
        this.notifier.notify("error", "Failed to save");
      }
    });
  }

  loadInitialData() {
    this.ipcService.invokeIPC("createDataForInitialSetup").then(res => {
      if (res) {
        this.notifier.notify("success", "Loading process invoked");
      }
    })
  }

  async activateLicense() {
    var machineDetails = await this.ipcService.invokeIPC("getMachineDetails", []);
    if (machineDetails === false) {
      machineDetails = { machineId: "machine-id-not-found", machineName: "unknown", os: "windows" };
    }

    const licenseKey = this.licenseNumber?.trim();
    const keyWithoutDashes = licenseKey?.replace(/-/g, '');
    if (!keyWithoutDashes || keyWithoutDashes.length !== 24) {
      this.notifier.notify("error", "Invalid license key. Expected format: xxxx-xxxx-xxxx-xxxx-xxxx-xxxx");
      return;
    }

    const payload = {
      license_key: licenseKey,
      machine_id: machineDetails['machineId'],
      machine_name: machineDetails['machineName'],
      os: machineDetails['os']
    };

    this.licenseService.activateLicense(payload).subscribe(result => {
      if (result && result["success"]) {
        const licenseData = JSON.stringify({
          license_key: licenseKey,
          expiry_date: result['expiry_date'] || result['data']?.expiry_date || null,
          status: result['status'] || result['data']?.status || 'active',
          machine_id: machineDetails['machineId']
        });
        this.ipcService.invokeIPC("saveLicense", [machineDetails['machineId'], licenseData]).then(() => {
          this.notifier.notify("success", "License successfully activated");
          this.isLicenseActive = true;
          this.getLicenseDetails();
        });
      } else {
        this.notifier.notify("error", result?.['message'] || "Failed to activate license");
      }
    });
  }

  async deactivateLicenseForMachine() {
    var machineDetails = await this.ipcService.invokeIPC("getMachineDetails", []);
    if (machineDetails === false) {
      machineDetails = { machineId: "machine-id-not-found", machineName: "unknown", os: "windows" };
    }

    const payload = {
      license_key: this.licenseNumber?.trim(),
      machine_id: machineDetails['machineId']
    };

    this.licenseService.deactivateLicenseForMachine(payload).subscribe(
      result => {
        this.ipcService.invokeIPC("removeLicense", [machineDetails['machineId']]).then(() => {
          this.isLicenseActive = false;
          this.licenseNumber = "";
          this.validTill = "";
          this.notifier.notify("success", "License successfully de-activated");
        });
      },
      () => {
        // Even if server call fails, remove locally so user can re-activate
        this.ipcService.invokeIPC("removeLicense", [machineDetails['machineId']]).then(() => {
          this.isLicenseActive = false;
          this.licenseNumber = "";
          this.validTill = "";
          this.notifier.notify("success", "License removed from this machine");
        });
      }
    );
  }
}
