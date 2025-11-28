// app/components/comment-section.js
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import isEqual from 'ticket-desk/helpers/is-equal';
import { fn } from '@ember/helper';
import { service } from '@ember/service';

// Format ISO date: 2025-11-27T13:15:30.328Z → 27/11/2025
function formatDate(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  let dd = String(date.getDate()).padStart(2, '0');
  let mm = String(date.getMonth() + 1).padStart(2, '0');
  let yyyy = date.getFullYear();

  return `${dd}/${mm}/${yyyy}`;
}

function getInitials(name) {
  if (!name) return '';
  return name.trim().charAt(0).toUpperCase();
}

function getRandomColor(name = 'a') {
  // create predictable color from name
  if (!name) return '#3b82f6';
  const colors = [
    '#3b82f6', // blue
    '#8b5cf6', // purple
    '#ec4899', // pink
    '#10b981', // green
    '#f59e0b', // amber
    '#ef4444', // red
    '#0ea5e9', // sky
  ];

  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash);
  }

  return colors[Math.abs(hash) % colors.length];
}

export default class CommentSectionComponent extends Component {
  @service session;
  @tracked newComment = '';
  @tracked isSubmitting = false;

  // Use comments from parent component
  get comments() {
    console.log('hgfhda', this.session.user);
    return this.args.comments ?? [];
  }

  // Sort comments by newest first
  get sortedComments() {
    return [...this.comments].sort((a, b) => {
      return new Date(b.created_at) - new Date(a.created_at);
    });
  }

  get isAddButtonDisabled() {
    return this.isSubmitting || !this.newComment.trim();
  }

  @action
  updateComment(event) {
    this.newComment = event.target.value;
  }

  @action
  async addComment() {
    if (!this.newComment.trim()) return;

    this.isSubmitting = true;

    const data = {
      content: this.newComment,
      author: this.session.user || 'admin',
    };

    await this.args.postComment(data);

    // Reset input
    this.newComment = '';
    this.isSubmitting = false;
  }

  @action
  async deleteComments(comment) {
    // Optional confirmation
    // if (!confirm('Are you sure you want to delete this comment?')) return;

    await this.args.deleteComment(comment); // call parent method

    // If parent updates @comments, no need to mutate this.comments
  }

  // Template
  <template>
    <div class="mx-auto mt-6 p-6 bg-white rounded-lg shadow-lg">

      {{! Header }}
      <div class="mb-6 border-b pb-4">
        <h2 class="text-2xl font-bold text-gray-800">Comments</h2>
        <p class="text-sm text-gray-500 mt-1">
          {{this.comments.length}}
          {{if (isEqual this.comments.length 1) "comment" "comments"}}
        </p>
      </div>

      {{! Add Comment }}
      <div class="mb-8">
        <div class="flex gap-3">
          <input
            type="text"
            value={{this.newComment}}
            {{on "input" this.updateComment}}
            placeholder="Write a comment..."
            class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            disabled={{this.isSubmitting}}
          />

          <button
            type="button"
            {{on "click" this.addComment}}
            disabled={{this.isAddButtonDisabled}}
            class="px-6 py-2 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
          >
            {{if this.isSubmitting "Adding..." "Add Comment"}}
          </button>
        </div>
      </div>

      {{! Comments List }}
      <div class="space-y-4">
        {{#each this.sortedComments as |comment|}}
          <div class="flex gap-4 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">

            <div
              class="w-10 h-10 rounded-full flex-shrink-0 flex items-center justify-center text-white font-bold"
              style="background-color: {{getRandomColor comment.author}}"
            >
              {{getInitials comment.author}}
            </div>

            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between mb-1">

                <div class="flex items-center gap-2">
                  <span class="font-semibold text-gray-900">{{comment.author}}</span>
                  <span class="text-xs text-gray-500">
                    {{formatDate comment.created_at}}
                  </span>
                </div>

                {{! Delete button }}
                <button
                  class="text-white text-xs hover:underline bg-red-400 py-3 px-8 rounded-lg"
                  {{on "click" (fn this.deleteComments comment.id)}}
                >
                  Delete
                </button>

              </div>

              <p class="text-gray-700 break-words">{{comment.content}}</p>
            </div>

          </div>
        {{else}}
          <div class="text-center py-8 text-gray-500">
            <p>No comments yet. Be the first to comment!</p>
          </div>
        {{/each}}
      </div>

    </div>
  </template>
}
