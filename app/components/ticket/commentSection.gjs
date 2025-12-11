// app/components/comment-section.js
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import isEqual from 'ticket-desk/helpers/is-equal';
import { fn } from '@ember/helper';
import { service } from '@ember/service';
import FileUploader from '../ui/fileUpload.gjs';
import formatDateTime from 'ticket-desk/utils/format-date-time';

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

function formatFileSize(bytes) {
  if (!bytes) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}

function isImageFile(contentType) {
  return contentType && contentType.startsWith('image/');
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

  get existedFile() {
    return this.args.existedFile;
  }

  get isImage() {
    return this.existedFile && isImageFile(this.existedFile.content_type);
  }

  @action
  updateComment(event) {
    let value = event.target.value;

    // always trim and force the input value
    value = value.slice(0, 200);

    this.newComment = value;
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

  @action
  removeAttachment() {
    if (this.args.onRemoveExistedFile) {
      this.args.onRemoveExistedFile();
    }
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
        <div class="flex gap-3 items-start">
          <div class="flex-1 flex flex-col">
            <input
              type="text"
              value={{this.newComment}}
              {{on "input" this.updateComment}}
              placeholder="Write a comment..."
              class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              disabled={{this.isSubmitting}}
            />
            <span class="self-end text-sm text-gray-1001">{{this.newComment.length}}/200</span>
          </div>

          <button
            type="button"
            {{on "click" this.addComment}}
            disabled={{this.isAddButtonDisabled}}
            class="px-6 py-2 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
          >
            {{if this.isSubmitting "Adding..." "Add Comment"}}
          </button>

          <FileUploader
            @existedFile={{@existedFile}}
            @uploadFile={{@uploadFile}}
            @onRemoveExistedFile={{this.removeAttachment}}
            @onFileChange={{this.handleFileChange}}
            @disabled={{this.isSubmitting}}
          />
        </div>
      </div>

      {{! File Preview Section }}
      {{#if this.existedFile}}
        <div
          class="mb-6 px-4 py-3 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg border-2 border-blue-200"
        >
          <div class="flex items-start gap-4">

            {{! Preview Area }}
            <div class="flex-shrink-0">
              {{#if this.isImage}}
                {{! Image Preview }}
                <div class="w-16 h-16 rounded-lg overflow-hidden shadow-md border-2 border-white">
                  <img
                    src={{this.existedFile.url}}
                    alt={{this.existedFile.filename}}
                    class="w-full h-full object-cover"
                  />
                </div>
              {{else}}
                {{! PDF/File Icon }}
                <div
                  class="w-16 h-16 rounded-lg bg-white shadow-md border-2 border-gray-200 flex flex-col items-center justify-center"
                >
                  <svg class="w-6 h-6 text-red-500 mb-2" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M4 4a2 2 0 012-2h4.586A2 2 0 0112 2.586L15.414 6A2 2 0 0116 7.414V16a2 2 0 01-2 2H6a2 2 0 01-2-2V4zm2 6a1 1 0 011-1h6a1 1 0 110 2H7a1 1 0 01-1-1zm1 3a1 1 0 100 2h6a1 1 0 100-2H7z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <span class="text-xs font-semibold text-gray-600 uppercase">
                    {{#if (isEqual this.existedFile.content_type "application/pdf")}}
                      PDF
                    {{else}}
                      File
                    {{/if}}
                  </span>
                </div>
              {{/if}}
            </div>

            {{! File Info }}
            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between">
                <div class="flex-1 min-w-0">
                  <h3 class="text-base font-semibold text-gray-800 truncate mb-1">
                    {{this.existedFile.filename}}
                  </h3>
                  <div class="flex flex-wrap gap-3 text-xs text-gray-600">
                    <span class="flex items-center gap-1">
                      <svg class="w-2 h-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                        />
                      </svg>
                      {{formatFileSize this.existedFile.byte_size}}
                    </span>
                    <span class="flex items-center gap-1">
                      <svg class="w-2 h-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                        />
                      </svg>
                      {{formatDateTime this.existedFile.created_at}}
                    </span>
                  </div>

                  {{! View/Download Link }}
                  {{!-- <a
                    href={{this.existedFile.url}}
                    target="_blank"
                    rel="noopener noreferrer"
                    class="inline-flex items-center gap-1 mt-3 text-sm text-blue-600 hover:text-blue-800 font-medium hover:underline"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                      />
                    </svg>
                    {{#if this.isImage}}
                      View Image
                    {{else}}
                      Open File
                    {{/if}}
                  </a> --}}
                </div>

                {{! Remove Button }}
                <button
                  type="button"
                  {{on "click" this.removeAttachment}}
                  class="flex-shrink-0 ml-4 p-2 text-red-600 hover:text-red-800 hover:bg-red-100 rounded-lg transition-colors"
                  title="Remove attachment"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                    />
                  </svg>
                </button>
              </div>
            </div>

          </div>
        </div>
      {{/if}}

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
                    {{formatDateTime comment.created_at}}
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
