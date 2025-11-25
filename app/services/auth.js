import Service from '@ember/service';
import { inject as service } from '@ember/service';

export default class AuthService extends Service {
  @service session;

  pendingRefresh = null;

  async login(email, password) {
    const res = await fetch('http://localhost:3000/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });

    const data = await res.json().catch(() => ({}));

    if (!res.ok) {
      throw new Error(data.message || 'Login failed');
    }

    this.session.login({
      token: data.token,
      refreshToken: data.refreshToken,
      user: data.user,
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

        const res = await fetch('http://localhost:3000/auth/refresh', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ refreshToken }),
        });

        const data = await res.json().catch(() => ({}));
        if (!res.ok) {
          this.session.logout();
          throw new Error(data.message || 'Refresh failed');
        }

        this.session.setToken({
          token: data.token,
          refreshToken: data.refreshToken,
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
      const token = this.session.token;
      await fetch('http://localhost:3000/auth/logout', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
        },
      });
    } catch (e) {
      console.error('Logout failed', e);
    } finally {
      this.session.logout();
    }
  }
}
