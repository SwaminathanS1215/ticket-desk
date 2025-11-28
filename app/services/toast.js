import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class ToastService extends Service {
  @tracked messages = [];

  success(message) {
    this.show(message, "success");
  }

  error(message) {
    this.show(message, "error");
  }

  show(message, type = "info") {
    let id = Date.now();

    this.messages = [
      ...this.messages,
      { id, message, type }
    ];

    setTimeout(() => this.remove(id), 3000);
  }

  remove(id) {
    this.messages = this.messages.filter(m => m.id !== id);
  }
}
