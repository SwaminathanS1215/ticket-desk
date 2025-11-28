// components/file-uploader.gjs
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

export default class FileUploaderComponent extends Component {
  @tracked errorMessage = '';

  acceptedFormats = '.jpg,.jpeg,.png,.pdf';
  acceptedMimeTypes = ['image/jpeg', 'image/png', 'application/pdf'];

  get files() {
    return this.args.files || [];
  }

  @action
  async handleFileSelect(event) {
    const selectedFiles = Array.from(event.target.files);
    this.errorMessage = '';

    const validFiles = [];

    for (const file of selectedFiles) {
      if (this.validateFile(file)) {
        const fileObj = {
          id: this.generateId(),
          file,
          name: file.name,
          size: this.formatFileSize(file.size),
          type: file.type,
          preview: null,
        };

        // Create preview only for images
        if (file.type.startsWith('image/')) {
          fileObj.preview = await this.generatePreview(file);
        }

        validFiles.push(fileObj);
      }
    }

    if (validFiles.length > 0) {
      console.log('validFiles', this.files, validFiles);
      // FIX: Use this.files (which has the fallback) instead of this.args.files
      const updatedFiles = [...this.args.files, ...validFiles];
      this.args.onFilesChange(updatedFiles);
    }

    // Reset input so same image can be selected again
    event.target.value = '';
  }

  @action
  removeFile(fileId) {
    const updated = this.files.filter((f) => f.id !== fileId);
    this.args.onFilesChange(updated);
  }

  generatePreview(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = (e) => resolve(e.target.result);
      reader.onerror = reject;
      reader.readAsDataURL(file);
    });
  }

  validateFile(file) {
    if (!this.acceptedMimeTypes.includes(file.type)) {
      this.errorMessage = `Invalid file: ${file.name}. Only JPG, PNG, PDF allowed.`;
      return false;
    }

    if (file.size > 5 * 1024 * 1024) {
      this.errorMessage = `File too large: ${file.name} (Max 5MB).`;
      return false;
    }

    return true;
  }

  generateId() {
    return `file_${Date.now()}_${Math.random().toString(36).slice(2)}`;
  }

  formatFileSize(bytes) {
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return (bytes / Math.pow(k, i)).toFixed(1) + ' ' + sizes[i];
  }

  <template>
    <div class="w-full">

      <!-- UPLOAD AREA -->
      <div class="mb-4">
        <label
          class="inline-flex flex-col items-center justify-center w-full px-4 py-6 bg-white border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:bg-gray-50 transition"
        >
          <input
            type="file"
            multiple
            accept={{this.acceptedFormats}}
            {{on "change" this.handleFileSelect}}
            class="hidden"
          />

          <svg
            class="w-10 h-10 text-gray-400 mb-3"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
            ></path>
          </svg>

          <span class="text-sm font-medium text-gray-700">Choose Files</span>
          <span class="text-xs text-gray-500">JPG, PNG, PDF only (Max 5MB)</span>
        </label>
      </div>

      <!-- ERROR MESSAGE -->
      {{#if this.errorMessage}}
        <div class="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg">
          <p class="text-sm text-red-600">{{this.errorMessage}}</p>
        </div>
      {{/if}}

      <!-- FILE COUNT -->
      <div class="mb-2 text-xs text-gray-500">
        Files selected:
        {{this.files.length}}
      </div>

      <!-- FILE LIST -->
      {{#if this.files.length}}
        <div class="flex flex-wrap gap-2">

          {{#each this.files as |file|}}
            <div
              class="inline-flex items-center gap-2 px-3 py-1.5 bg-blue-100 text-blue-800 rounded-full text-sm font-medium"
            >

              {{! IMAGE PREVIEW }}
              {{#if file.preview}}
                <img
                  src={{file.preview}}
                  alt={{file.name}}
                  class="w-5 h-5 rounded-full object-cover"
                />
              {{else}}
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M7 21h10a2 2 0 002-2V9.4a1 1 0 00-.3-.7L13.3 3.3A1 1 0 0012.6 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                  >
                  </path>
                </svg>
              {{/if}}

              <span class="max-w-xs truncate">{{file.name}} ({{file.size}})</span>

              <button
                type="button"
                {{on "click" (fn this.removeFile file.id)}}
                class="hover:bg-blue-200 rounded-full p-0.5"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>

            </div>
          {{/each}}
        </div>
      {{else}}
        <div class="text-sm text-gray-500">No files selected</div>
      {{/if}}
    </div>
  </template>
}
