import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class AppRoute extends Route {
  @service session;
  @service router;
  @service notificationService;
  @service enumsService;

  async beforeModel() {
    if (!this.session.isAuthenticated) {
      this.router.transitionTo('/');
    }
    await this.notificationService.load();
    if(!this.enumsService.properties || Object.keys(this.enumsService.properties).length === 0) {
      await this.enumsService.load();
    }
  }
}
