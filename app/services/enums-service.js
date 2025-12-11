import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { API_ENDPOINTS } from '../constants';
import { service } from '@ember/service';

export default class EnumsService extends Service {
  @service api;

  @tracked properties = {};

  constructor() {
    super(...arguments);
    if (localStorage.getItem('enums')) {
      this.properties = JSON.parse(localStorage.getItem('enums'));
    } else {
      this.load();
    }
  }

  async load() {
    const response = await this.api.getJson(API_ENDPOINTS.GET_ENUMS);
    this.properties = response || {};
    localStorage.setItem('enums', JSON.stringify(this.properties));
  }
}
