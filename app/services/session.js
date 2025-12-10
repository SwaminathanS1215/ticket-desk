import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';

const STORAGE_TOKEN = 'auth_token';
const STORAGE_REFRESH = 'auth_refresh';
const STORAGE_ROLE = 'auth_role';
const STORAGE_EMAIL = 'auth_email';

export default class SessionService extends Service {
  @service router;

  @tracked token = null;
  @tracked refreshToken = null;
  @tracked role = null;
  @tracked email = null;

  get isAuthenticated() {
    return Boolean(this.token);
  }

  constructor() {
    super(...arguments);

    try {
      const token = localStorage.getItem(STORAGE_TOKEN);
      const refresh = localStorage.getItem(STORAGE_REFRESH);
      const role = localStorage.getItem(STORAGE_ROLE);
      const email = localStorage.getItem(STORAGE_EMAIL);

      if (token) {
        this.token = token;
        this.refreshToken = refresh;
        this.role = role || null;
        this.email = email || null;
      }
    } catch (e) {
      console.error('Failed to initialize session from storage', e);
    }
  }

  login({ token, refreshToken, role, email }) {
    this.token = token;
    this.refreshToken = refreshToken;
    this.role = role || null;
    this.email = email || null;

    localStorage.setItem(STORAGE_TOKEN, token);
    localStorage.setItem(STORAGE_REFRESH, refreshToken);
    localStorage.setItem(STORAGE_ROLE, this.role);
    localStorage.setItem(STORAGE_EMAIL, this.email);
  }

  setToken({ token, refreshToken, role, email }) {
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

    if (email) {
      this.email = email;
      localStorage.setItem(STORAGE_EMAIL, email);
    }
  }

  logout() {
    this.token = null;
    this.refreshToken = null;
    this.role = null;
    this.email = null;

    localStorage.removeItem(STORAGE_TOKEN);
    localStorage.removeItem(STORAGE_REFRESH);
    localStorage.removeItem(STORAGE_ROLE);
    localStorage.removeItem(STORAGE_EMAIL);
    this.router.transitionTo('/');
  }
}
