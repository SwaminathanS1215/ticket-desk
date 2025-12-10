import Controller from '@ember/controller';
import { action } from '@ember/object';
import { service } from '@ember/service';

export default class AppTicketDetailsController extends Controller {
  @service api;
  @service router;

  @action
  async postComment(commentData) {
    try {
      await this.api.postJson(
        `/api/version1/tickets/${this.model.ticket_id}/comments`,
        commentData
      );

      // Refresh the route to refetch comments
      this.send('refreshModel');
    } catch (error) {
      console.error('Error posting comment:', error);
    }
  }

  @action
  async deleteComment(commentId) {
    try {
      await this.api.deleteTicket(
        `/api/version1/tickets/${this.model.ticket_id}/comments/${commentId}`
      );

      // Refresh the route to refetch comments
      this.send('refreshModel');
    } catch (error) {
      console.error('Error deleting comment:', error);
    }
  }
  @action async uploadFile(file) {
    const data = await this.api.postFile(
      `api/version1/tickets/${this.model.ticket_id}/attachment`,
      file
    );
    this.send('refreshModel');
    return data;
  }

  @action async removeAttachment() {
    const data = await this.api.deleteTicket(
      `api/version1/tickets/${this.model.ticket_id}/attachment`
    );
    this.send('refreshModel');
    return data;
  }
}
