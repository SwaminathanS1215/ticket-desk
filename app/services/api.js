import Service from '@ember/service';
import { service } from '@ember/service';
import config from '../config/environment';

export default class ApiService extends Service {
  @service session;
  @service auth;

  apiHost = config.APP.apiHost;

  constructor() {
    super(...arguments);
    console.log('ApiService LOADED');
  }

  buildUrl(path) {
    if (path.startsWith('http')) return path;
    return `${this.apiHost}${path}`;
  }

  async request(path, options = {}, { retry = true } = {}) {
    const url = this.buildUrl(path);
    const token = this.session.token;

    const headers = new Headers(options.headers || {});

    if (!(options.body instanceof FormData)) {
      headers.set('Content-Type', headers.get('Content-Type') || 'application/json');
    }

    if (token) {
      headers.set('Authorization', `Bearer ${token}`);
    }

    const res = await fetch(url, { ...options, headers });

    // Handle token refresh
    if (res.status === 401 && retry && token) {
      this.session.logout();
    }

    return res;
  }

  // GET JSON
  async getJson(path) {
    const res = await this.request(path, { method: 'GET' });
    if (!res.ok) throw new Error(`Request failed: ${res.status}`);
    return res.json();
  }

  // POST JSON
  async postJson(path, body) {
    const res = await this.request(path, {
      method: 'POST',
      body: JSON.stringify(body),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data?.error || `Request failed: ${res.status}`);
    }
    return res.json();
  }
  // POST FILE
  async postFile(path, body) {
    const res = await this.request(path, {
      method: 'POST',
      body: body,
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data?.error || `Request failed: ${res.status}`);
    }
    return res.json();
  }
  // PUT JSON
  async putJson(path, body) {
    const res = await this.request(path, {
      method: 'PUT',
      body: JSON.stringify(body),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data?.error || `Request failed: ${res.status}`);
    }
    return res.json();
  }

  async delete(path) {
    const res = await this.request(path, {
      method: 'DELETE',
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data?.error || `Request failed: ${res.status}`);
    }
    return res.json();
  }

  async patchJson(path, body) {
    const res = await this.request(path, {
      method: 'PATCH',
      body: JSON.stringify(body),
    });
    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data?.error || `Request failed: ${res.status}`);
    }
    return res.json();
  }
}
