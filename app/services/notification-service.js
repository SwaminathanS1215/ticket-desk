import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { API_ENDPOINTS } from '../constants';

export default class NotificationsService extends Service {
  @tracked items = [];
  @service api;
  @service session;
  @tracked hasUnread = false;

  constructor() {
    super(...arguments);
    this.startPolling();
  }

  async startPolling() {
    this.load();
    const interval = setInterval(() => {
      if (!this.session.isAuthenticated) {
        clearInterval(interval);
        return;
      }
      this.load();
    }, 5000);
  }

  async load() {
    const res = await this.api.getJson(API_ENDPOINTS.GET_NOTIFICATIONS);
    if(res.some((item) => !item.read)) {
      this.hasUnread = true;
    } else {
      this.hasUnread = false;
    }
    this.items = res;
  }

  async markAsRead(id) {
    await this.api.patchJson(API_ENDPOINTS.MARK_NOTIFICATIONS_READ, { id });
    this.items = this.items.map((item) => {
      if (item.id === id) {
        return { ...item, read: true };
      }
      return item;
    });
  }

  async markAllAsRead() {
    await this.api.patchJson(API_ENDPOINTS.MARK_ALL_NOTIFICATIONS_READ);
    this.items = this.items.map((item) => ({ ...item, read: true }));
  }
}
