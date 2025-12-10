import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { API_ENDPOINTS } from '../constants';

export default class NotificationsService extends Service {
  @tracked items = [];
  @service api;

  constructor() {
    super(...arguments);
    this.startPolling();
  }

  async startPolling() {
    this.load();
    setInterval(() => this.load(), 5000);
  }

  async load() {
    const res = await this.api.getJson(API_ENDPOINTS.GET_NOTIFICATIONS);
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
