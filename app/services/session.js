import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

const STORAGE_KEY = 'ticketdesk-session';

export default class SessionService extends Service {
  @tracked isAuthenticated = false;
  @tracked user = null;

  constructor() {
    super(...arguments);
    this.restore();
  }

  login(user) {
    this.isAuthenticated = true;
    this.user = user;
    this.persist();
  }

  logout() {
    this.isAuthenticated = false;
    this.user = null;
    localStorage.removeItem(STORAGE_KEY);
  }

  persist() {
    localStorage.setItem(
      STORAGE_KEY,
      JSON.stringify({
        isAuthenticated: this.isAuthenticated,
        user: this.user
      })
    );
  }

  restore() {
    let saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      try {
        let data = JSON.parse(saved);
        this.isAuthenticated = data.isAuthenticated;
        this.user = data.user;
      } catch (e) {
        console.error('Session restore failed:', e);
      }
    }
  }
}
