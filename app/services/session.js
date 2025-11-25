import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

const STORAGE_TOKEN = 'auth_token';
const STORAGE_REFRESH = 'auth_refresh';
const STORAGE_ROLE = 'auth_role';

export default class SessionService extends Service {
  @tracked token = null;
  @tracked refreshToken = null;
  @tracked role = null;

  get isAuthenticated() {
    return Boolean(this.token);
  }

  constructor() {
    super(...arguments);

    try {
      const token = localStorage.getItem(STORAGE_TOKEN);
      const refresh = localStorage.getItem(STORAGE_REFRESH);
      const role = localStorage.getItem(STORAGE_ROLE);

      if (token) {
        this.token = token;
        this.refreshToken = refresh;
        this.role = role || null;
      }
    } catch (e) {
      console.error('Failed to initialize session from storage', e);
    }
  }

  login({ token, refreshToken, role }) {
    this.token = token;
    this.refreshToken = refreshToken;
    this.role = role || null;

    localStorage.setItem(STORAGE_TOKEN, token);
    localStorage.setItem(STORAGE_REFRESH, refreshToken);
    localStorage.setItem(STORAGE_ROLE, this.role);
  }

  setToken({ token, refreshToken, role }) {
    if (token) {
      this.token = token;
      localStorage.setItem(STORAGE_TOKEN, token);
    }

    if (refreshToken) {
      this.refreshToken = refreshToken;
      localStorage.setItem(STORAGE_REFRESH, refreshToken);
    }

    if (role) {
      this.role = role;
      localStorage.setItem(STORAGE_ROLE, role);
    }
  }

  logout() {
    this.token = null;
    this.refreshToken = null;
    this.role = null;

    localStorage.removeItem(STORAGE_TOKEN);
    localStorage.removeItem(STORAGE_REFRESH);
    localStorage.removeItem(STORAGE_ROLE);
  }
}
