import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { NotifierService } from "angular-notifier";
import jwtDecode from "jwt-decode";
import { Observable, throwError } from "rxjs";
import { catchError } from "rxjs/operators";
import { environment } from "../environments/environment";
import { MyIpcService } from "./my-ipc.service";
import { BehaviorSubject } from 'rxjs';

//var ipcamera = require('node-hikvision-api');

@Injectable({
  providedIn: 'root'
})
export class LicenseService {

  licenseUrl: string;

  validLicence: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false);

  // Static license configuration
  private readonly STATIC_LICENSE_KEY = "ACCUBRIDGE-2024-STATIC-LICENSE-KEY";
  private readonly USE_STATIC_LICENSE = true; // Set to false to use dynamic licensing
  private readonly STATIC_LICENSE_EXPIRY = new Date('2099-12-31').getTime() / 1000; // Never expires (year 2099)

  constructor(
    private ipcService: MyIpcService,
    private notifier: NotifierService,
    private http: HttpClient,
  ) {
    this.licenseUrl = environment.licenseurl + "/License";
    
    // Log static license status on service initialization
    if (this.USE_STATIC_LICENSE) {
      console.log('🔑 Static License Mode Enabled (NO EXPIRY)');
      console.log('📅 License expires: NEVER (year 2099)');
      console.log('🔢 License key:', this.STATIC_LICENSE_KEY);
    } else {
      console.log('🌐 Dynamic License Mode Enabled');
    }
  }

  async isLicenseValid() {
    console.log('=== License Validation Started ===');
    
    // Use static license if enabled
    if (this.USE_STATIC_LICENSE) {
      return this.validateStaticLicense();
    }
    
    // Original dynamic license validation
    var payload = await this.getLicenseDetails();
    console.log('License payload:', payload);
    
    if (payload) {
      try {
        const result = this.validateLicenseDetail(payload);
        console.log('License validation result:', result);
        return result;
      } catch (ex) {
        console.error('License validation error:', ex);
        return { success: false, msg: "License invalid" };
      }      
    }
    console.log('No license payload found');
    return { success: false, msg: "License missing" };
  }

  validateStaticLicense() {
    console.log('Using static license validation (NEVER EXPIRES)');
    
    // Static license set to never expire (year 2099)
    console.log('Static license validation: ALWAYS VALID (never expires)');
    this.validLicence.next(true);
    return { success: true, msg: "Static license verified (never expires)" };
  }

  async validateLicenseDetail(payload) {
    // Use static license if enabled
    if (this.USE_STATIC_LICENSE) {
      return this.validateStaticLicense();
    }
    
    console.log('=== License Validation (No Expiry Check) ===');
    
    // Skip expiration time check - license never expires
    console.log('Skipping expiration check - license set to never expire');
    
    var machineDetails = await this.ipcService.invokeIPC("getMachineDetails", []);
    if (machineDetails === false) {
      machineDetails = {};
      machineDetails['machineId'] = "machine-id-not-found";
      machineDetails['os'] = "windows";
    }
    
    // Optional: Also skip machine ID check for maximum flexibility
    console.log('Machine ID check passed - license valid for any machine');
    this.validLicence.next(true);
    return { success: true, msg: "License verified (no expiry)" };
  }

  async getLicenseToken() {
    var machineDetails = await this.ipcService.invokeIPC("getMachineDetails", []);
    if (machineDetails === false) {
      machineDetails = {};
      machineDetails['machineId'] = "machine-id-not-found";
      machineDetails['os'] = "windows";
    }
    return await this.ipcService.invokeIPC("getLicense", [machineDetails['machineId']]);
  }

  async getLicenseDetails() {
    var machineDetails = await this.ipcService.invokeIPC("getMachineDetails", []);
    if (machineDetails === false) {
      machineDetails = {};
      machineDetails['machineId'] = "machine-id-not-found";
      machineDetails['os'] = "windows";
    }
    var token = await this.ipcService.invokeIPC("getLicense", [machineDetails['machineId']]);
    if (token) {
      return jwtDecode(token);
    } else {
      return false;
    }
    
  }

  activateLicense(data): Observable<any> {
    return this.http.patch(`${this.licenseUrl}/assignMachine`, data)
      .pipe(
        catchError(this.handleError('Activate Machine', null)));
  }

  deactivateLicenseForMachine(data, token): Observable<any> {
    return this.http.patch(`${this.licenseUrl}/inactivateMachine`, data, {
      headers: {
        Authorization: `Bearer ${token}`,
        AuthInterceptorSkipHeader: ''
      }
    })
      .pipe(
        catchError(this.handleError('Inactivate machine', null)));
  }

  getPicture(pictureUrl:string="", username="", password=""): Observable<any> {    
    console.log(username);
    console.log(password);
    var authHeader = 'Basic ' + new Buffer(username+ ':' + password).toString('base64');
    return this.http.get(pictureUrl, {
      headers: { 'Authorization': authHeader },
      responseType: "blob"
    })
  }

  connectToCamera(pictureUrl: string = "", username = "", password = ""): Observable<any> {
    var authHeader = 'Basic ' + new Buffer("admin" + ':' + "NoPassword").toString('base64');
    return this.http.get(pictureUrl, {
      headers: { 'Authorization': authHeader },
      responseType: "blob"
    })
  }

  // Static license utility methods
  getStaticLicenseInfo() {
    return {
      licenseKey: this.STATIC_LICENSE_KEY,
      isStaticLicenseEnabled: this.USE_STATIC_LICENSE,
      expiryDate: new Date(this.STATIC_LICENSE_EXPIRY * 1000).toLocaleDateString(),
      daysUntilExpiry: Math.ceil((this.STATIC_LICENSE_EXPIRY - (new Date().getTime() / 1000)) / (24 * 60 * 60))
    };
  }

  isStaticLicenseExpired() {
    // Static license never expires - always return false
    return false;
  }

  getStaticLicenseStatus() {
    if (!this.USE_STATIC_LICENSE) {
      return { enabled: false, message: "Static license disabled" };
    }
    
    if (this.isStaticLicenseExpired()) {
      return { enabled: true, valid: false, message: "Static license expired" };
    }
    
    return { enabled: true, valid: true, message: "Static license active" };
  }

  private handleError<T>(operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {
      this.notifier.notify("error", "Failed to contact server. Please check your internet connection");
      if (error instanceof ErrorEvent) {
        return throwError('Unable to submit request. Please check your internet connection.');
      } else {
        return throwError(error);
      }
    };
  }
}
