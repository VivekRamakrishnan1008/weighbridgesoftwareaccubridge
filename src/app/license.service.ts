import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { NotifierService } from "angular-notifier";
import { Observable, throwError } from "rxjs";
import { catchError } from "rxjs/operators";
import { MyIpcService } from "./my-ipc.service";
import { BehaviorSubject } from 'rxjs';

const LICENSE_SERVER = "https://license.agentfloww.com";
const PRODUCT = "agentfloww";

@Injectable({
  providedIn: 'root'
})
export class LicenseService {

  validLicence: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false);

  constructor(
    private ipcService: MyIpcService,
    private notifier: NotifierService,
    private http: HttpClient,
  ) {}

  async isLicenseValid() {
    var payload = await this.getLicenseDetails();
    if (payload) {
      try {
        return this.validateLicenseDetail(payload);
      } catch (ex) {
        console.error('License validation error:', ex);
        return { success: false, msg: "License invalid" };
      }
    }
    return { success: false, msg: "License missing" };
  }

  async validateLicenseDetail(payload: any) {
    if (!payload) {
      return { success: false, msg: "License missing" };
    }

    // Check status
    if (payload['status'] !== 'active') {
      this.validLicence.next(false);
      return { success: false, msg: "License is not active" };
    }

    // Check expiry
    if (payload['expiry_date']) {
      var expiry = new Date(payload['expiry_date']);
      expiry.setHours(23, 59, 59, 999);
      if (expiry < new Date()) {
        this.validLicence.next(false);
        return { success: false, msg: "License has expired" };
      }
    }

    // Check machine binding
    var machineDetails = await this.ipcService.invokeIPC("getMachineDetails", []);
    if (machineDetails === false) {
      machineDetails = { machineId: "machine-id-not-found" };
    }
    if (payload['machine_id'] && payload['machine_id'] !== machineDetails['machineId']) {
      this.validLicence.next(false);
      return { success: false, msg: "License is not valid for this machine" };
    }

    this.validLicence.next(true);
    return { success: true, msg: "License verified" };
  }

  async getLicenseDetails(): Promise<any> {
    var machineDetails = await this.ipcService.invokeIPC("getMachineDetails", []);
    if (machineDetails === false) {
      machineDetails = { machineId: "machine-id-not-found" };
    }
    var raw = await this.ipcService.invokeIPC("getLicense", [machineDetails['machineId']]);
    if (raw) {
      try {
        return JSON.parse(raw);
      } catch {
        return false;
      }
    }
    return false;
  }

  async getLicenseToken() {
    var machineDetails = await this.ipcService.invokeIPC("getMachineDetails", []);
    if (machineDetails === false) {
      machineDetails = { machineId: "machine-id-not-found" };
    }
    return await this.ipcService.invokeIPC("getLicense", [machineDetails['machineId']]);
  }

  activateLicense(data: {
    license_key: string;
    machine_id: string;
    machine_name: string;
    os: string;
  }): Observable<any> {
    return this.http.post(
      `${LICENSE_SERVER}/api/activate-license?product=${PRODUCT}`,
      data
    ).pipe(
      catchError(this.handleError('Activate License', null))
    );
  }

  deactivateLicenseForMachine(data: any): Observable<any> {
    return this.http.post(
      `${LICENSE_SERVER}/api/deactivate-license?product=${PRODUCT}`,
      data
    ).pipe(
      catchError(this.handleError('Deactivate License', null))
    );
  }

  getPicture(pictureUrl: string = "", username = "", password = ""): Observable<any> {
    var authHeader = 'Basic ' + new Buffer(username + ':' + password).toString('base64');
    return this.http.get(pictureUrl, {
      headers: { 'Authorization': authHeader },
      responseType: "blob"
    });
  }

  connectToCamera(pictureUrl: string = "", username = "", password = ""): Observable<any> {
    var authHeader = 'Basic ' + new Buffer("admin" + ':' + "NoPassword").toString('base64');
    return this.http.get(pictureUrl, {
      headers: { 'Authorization': authHeader },
      responseType: "blob"
    });
  }

  private handleError<T>(operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {
      this.notifier.notify("error", "Failed to contact license server. Please check your internet connection");
      if (error instanceof ErrorEvent) {
        return throwError('Unable to submit request. Please check your internet connection.');
      } else {
        return throwError(error);
      }
    };
  }
}

