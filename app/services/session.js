import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

const STORAGE_TOKEN = 'auth_token';
const STORAGE_REFRESH = 'auth_refresh';
const STORAGE_USER = 'auth_user';

export default class SessionService extends Service {
  @tracked isAuthenticated = false;
  @tracked user = null;
  @tracked token = null;
  @tracked refreshToken = null;

  constructor() {
    super(...arguments);
    try {
      const token = localStorage.getItem(STORAGE_TOKEN);
      const refresh = localStorage.getItem(STORAGE_REFRESH);
      const userJson = localStorage.getItem(STORAGE_USER);

      if (token) {
        this.token = token;
        this.refreshToken = refresh;
        this.user = userJson ? JSON.parse(userJson) : null;
        this.isAuthenticated = true;
      }
    } catch (e) {
      console.error('Failed to initialize session from storage', e);
    }
  }

  login({ token, refreshToken, user }) {
    this.token = token;
    this.refreshToken = refreshToken;
    this.user = user || null;
    this.isAuthenticated = !!token;

    localStorage.setItem(STORAGE_TOKEN, token);
    localStorage.setItem(STORAGE_REFRESH, refreshToken);
    if (user) {
      localStorage.setItem(STORAGE_USER, JSON.stringify(user));
    }
  }

  setToken({ token, refreshToken }) {
    this.token = token;
    if (refreshToken) {
      this.refreshToken = refreshToken;
      localStorage.setItem(STORAGE_REFRESH, refreshToken);
    }
    if (token) localStorage.setItem(STORAGE_TOKEN, token);
    this.isAuthenticated = !!this.token;
  }

  logout() {
    this.isAuthenticated = false;
    this.user = null;
    this.token = null;
    this.refreshToken = null;
    localStorage.removeItem(STORAGE_TOKEN);
    localStorage.removeItem(STORAGE_REFRESH);
    localStorage.removeItem(STORAGE_USER);
  }
}
