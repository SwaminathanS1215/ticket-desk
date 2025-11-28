import Service from '@ember/service';
import { service } from '@ember/service';

export default class AuthService extends Service {
  @service session;
  @service api;
  @service router;

  pendingRefresh = null;

  async login(email, password) {
    const data = await this.api.postJson('/auth/login', {
      email,
      password,
    });

    this.session.login({
      token: data.access_token,
      refreshToken: data.refresh_token,
      role: data.role,
      email: email,
    });

    return data;
  }

  async refresh() {
    if (this.pendingRefresh) {
      return this.pendingRefresh;
    }

    this.pendingRefresh = (async () => {
      try {
        const refreshToken = this.session.refreshToken;
        if (!refreshToken) {
          throw new Error('No refresh token available');
        }

        const data = await this.api.postJson('/auth/refresh', {
          refreshToken,
        });

        this.session.setToken({
          token: data.access_token,
          refreshToken: data.refresh_token,
        });

        return data;
      } finally {
        this.pendingRefresh = null;
      }
    })();

    return this.pendingRefresh;
  }

  async logout() {
    try {
      await this.api.postJson('/auth/logout', {});
    } catch (e) {
      console.error('Logout failed', e);
    } finally {
      this.session.logout();
    }
  }

  async signup(payload) {
    const res = await this.api.postJson('/auth/signup', payload);
    return res;
  }
}
