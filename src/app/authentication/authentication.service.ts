import { Injectable, Inject } from '@angular/core';
import { environment } from './../../environments/environment';
import {HttpClient, HttpHeaders, HttpErrorResponse} from '@angular/common/http';
import {Observable, of, throwError} from 'rxjs';
import { BehaviorSubject } from 'rxjs';
import { retry, catchError, map, tap } from 'rxjs/operators';
import {AuthResponse} from './auth-response';
import { Router } from '@angular/router';
import { NotifierService } from 'angular-notifier';
import { MyDbService } from '../my-db.service';
import { QueryList } from '../query-list';
import { Utils } from '../utils';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type':  'application/json',
    AuthInterceptorSkipHeader:''    
  })
};

@Injectable({
  providedIn: 'root'
})

export class AuthenticationService {

  redirectUrl: string;
  loginUrl: string;
  signupUrl: string;
  isLoggedIn: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false);

  constructor(
    private http: HttpClient,
    private dbService: MyDbService,
    private router: Router,
    private notifier: NotifierService
  ) {
  	this.loginUrl = '/UserLogin/login';
    this.signupUrl = '/UserLogin';
    var loginStatus = this.getTokenOrOtherStoredData("isLoggedIn");
    if (loginStatus === 'true') {
      this.isLoggedIn.next(loginStatus);
    }
  }

  authorizeUser(accessListReqd: string[]):boolean{
      if (this.getTokenOrOtherStoredData()){
        if(accessListReqd===undefined || accessListReqd.length == 0){
          return true;
        }
        let permissionList:any = this.getTokenOrOtherStoredData('permissions')
        if(permissionList === undefined){
          return false;
        }
        var allowedPermissionList = JSON.parse(permissionList);
        return accessListReqd.every((ele)=> 
        {  
          return allowedPermissionList.some(ele1 => {
            if (ele1.id === ele)
              return true;
          })
        })
      }else{
        return false;
      }
      
  }

  getTokenOrOtherStoredData(key='isLoggedIn'):any {
    if (sessionStorage.getItem(key)) {
      return sessionStorage.getItem(key);
    } else {
      return "";
    }
  }

  signup(registrationData): Observable<AuthResponse> {
  	const mRegistrationData = {
  		userid: registrationData.username,
  		name: registrationData.name,
  		mobile: registrationData.mobile,
  		email: registrationData.email,
  		password: registrationData.password
  	};
  	return this.http.post<AuthResponse>(
  		this.signupUrl, registrationData, httpOptions)
  		.pipe(
  			retry(2),
  			catchError(this.handleError('registration', null))
  		);
  }

  async login(credentials) {
    console.log('=== AuthenticationService.login called ===');
    console.log('Credentials:', { username: credentials.username, password: credentials.password ? '***' : 'empty' });
    
    // First, let's check what users exist in the database
    console.log('=== Checking existing users ===');
    try {
      var allUsers = await this.dbService.executeSyncDBStmt("SELECT", "SELECT username, id FROM app_user");
      console.log('All users in database:', allUsers);
    } catch (error) {
      console.error('Error fetching users:', error);
    }
    
    // Check if user exists with just username
    try {
      var userCheck = await this.dbService.executeSyncDBStmt("SELECT", 
        `SELECT username, password, id FROM app_user WHERE username='${Utils.mysql_real_escape_string(credentials.username)}'`);
      console.log('User check result:', userCheck);
    } catch (error) {
      console.error('Error checking user:', error);
    }
    
    var stmt = QueryList.GET_USER_BY_CREDENTIALS
      .replace("{username}", Utils.mysql_real_escape_string(credentials.username))
      .replace("{password}", Utils.mysql_real_escape_string(credentials.password));

    console.log('Generated SQL statement:', stmt);
    console.log('Executing database query...');
    
    try {
      var result = await this.dbService.executeSyncDBStmt("SELECT", stmt);
      console.log('Database query result:', result);
      console.log('Result length:', result ? result.length : 'null/undefined');
      
      if (result && result.length > 0) {
        console.log('User found, getting permissions...');
        var permissions = await this.dbService.executeSyncDBStmt(
          "SELECT", QueryList.GET_USER_PERMISSIONS.replace("{userid}", result[0]['id']));
        console.log('User permissions:', permissions);
        
        result[0]['permissions'] = JSON.stringify(permissions);
        this.isLoggedIn.next(true);
        this.storeLocalData(result[0]);
        this.notifier.notify("success", "Login successfull");
        console.log('Login successful, user data stored');
        return true;
      } else {
        console.log('No user found with these credentials');
        this.isLoggedIn.next(false);
        this.notifier.notify("error", "Login failed");
        return false;
      }
    } catch (error) {
      console.error('Database error during login:', error);
      this.isLoggedIn.next(false);
      this.notifier.notify("error", "Login failed: Database error");
      return false;
    }
  }

  logout(): void{
    localStorage.clear();
    sessionStorage.clear();
    this.router.navigate(['']);
    this.isLoggedIn.next(false);
  }

  storeLocalData(data: any): void {
    sessionStorage.setItem('fullname', data.fullname);
    sessionStorage.setItem('role', data.role);
    sessionStorage.setItem('permissions', data.permissions);
    sessionStorage.setItem('isLoggedIn', 'true');
    sessionStorage.setItem('id', data.id);
    this.isLoggedIn.next(true);
  }

  patchStoredData(data: any):void{
    Object.keys(data).forEach((key)=>{
      if(localStorage.getItem(key)){
        localStorage.setItem(key, data[key]);
      }
      if(sessionStorage.getItem(key)){
        sessionStorage.setItem(key, data[key]);
      }
    });
  }

  handleForbiddenRequest(error){
    this.redirectUrl = this.router.url
    this.router.navigate(['', {'error':[error.error.msg]}])
    localStorage.clear();
    sessionStorage.clear();
    this.isLoggedIn.next(false);
  }

  /**
 * Handle Http operation that failed.
 * Let the app continue.
 * @param operation - name of the operation that failed
 * @param result - optional value to return as the observable result
 */
  handleError<T> (operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {
      // Let the app keep running by returning an empty result.
      if(error instanceof HttpErrorResponse && error.status === 403){
        this.redirectUrl = this.router.url
        this.router.navigate(['/login', {'error':[error.error.msg]}])
        localStorage.clear();
        sessionStorage.clear();
        this.isLoggedIn.next(false);
      }else if(error instanceof HttpErrorResponse && error.status === 500){
        this.notifier.notify("error", error.error.msg);
        this.notifier.notify("error", "Server error. Please contact developer");
        return throwError(error);
      }else if (error instanceof ErrorEvent) {
    		return throwError('Unable to submit request. Please check your internet connection.');
    	} else {
    		return throwError(error);
    	}
    };
  }
}
