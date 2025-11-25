import Service from '@ember/service';
import { inject as service } from '@ember/service';

export default class ApiService extends Service {
  @service session;
  @service auth;

  async request(url, options = {}, { retry = true } = {}) {
    const token = this.session.token;
    const headers = new Headers(options.headers || {});
    headers.set('Content-Type', headers.get('Content-Type') || 'application/json');
    if (token) {
      headers.set('Authorization', `Bearer ${token}`);
    }

    const res = await fetch(url, { ...options, headers });

    if (res.status === 401 && retry) {
      try {
        await this.auth.refresh();
        return this.request(url, options, { retry: false });
      } catch (err) {
        this.session.logout();
        throw err;
      }
    }

    return res;
  }

  async getJson(url) {
    const res = await this.request(url, { method: 'GET' });
    if (!res.ok) throw new Error(`Request failed: ${res.status}`);
    return res.json();
  }

  async postJson(url, body) {
    const res = await this.request(url, {
      method: 'POST',
      body: JSON.stringify(body),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.message || `Request failed: ${res.status}`);
    }
    return res.json();
  }
}
