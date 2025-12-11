// components/file-uploader.gjs
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

export default class FileUploaderComponent extends Component {
  @tracked errorMessage = '';
  @tracked isUploading = false;
  @tracked uploadedFile = null;

  acceptedFormats = 'pdf';
  acceptedMimeTypes = ['application/pdf'];

  get hasFile() {
    return this.args.existedFile;
  }

  get currentFile() {
    const file = this.args.existedFile;
    if (!file) return null;

    // Normalize server file format to component format
    if (file.filename && !file.name) {
      return {
        id: file.id || this.generateId(),
        name: file.filename,
        size: file.byte_size ? this.formatFileSize(file.byte_size) : null,
        type: file.content_type,
        url: file.url,
        created_at: file.created_at,
        isUploading: false,
        isLocal: false,
        preview: null,
      };
    }

    return file;
  }

  get isImageFile() {
    const file = this.currentFile;
    if (!file) return false;

    // Check if it's an image type
    const type = file.type || file.content_type || '';
    return type === 'image/jpeg' || type === 'image/png' || type.startsWith('image/');
  }

  get shouldShowImageIcon() {
    return this.currentFile?.preview || (this.currentFile?.url && this.isImageFile);
  }

  get isDisabled() {
    return this.isUploading || this.hasFile;
  }

  @action
  async handleFileSelect(event) {
    const selectedFile = event.target.files[0];
    this.errorMessage = '';

    if (!selectedFile) return;

    // Validate file
    if (!this.validateFile(selectedFile)) {
      event.target.value = '';
      return;
    }

    // Upload file
    await this.uploadFile(selectedFile);

    // Reset input
    event.target.value = '';
  }

  @action
  async uploadFile(file) {
    this.isUploading = true;

    // Create temporary file object with loading state
    const fileObj = {
      id: this.generateId(),
      file,
      name: file.name,
      size: this.formatFileSize(file.size),
      type: file.type,
      preview: null,
      isUploading: true,
      url: null,
      isLocal: true,
    };

    // Generate preview for images
    if (file.type.startsWith('image/')) {
      fileObj.preview = await this.generatePreview(file);
    }

    // Set uploading state
    this.uploadedFile = fileObj;

    try {
      // Create FormData
      const formData = new FormData();
      formData.append('attachment', file);

      const data = await this.args.uploadFile(formData);

      // Update file object with URL from response
      const updatedFile = {
        ...fileObj,
        isUploading: false,
        url: data.url,
        isLocal: true,
      };

      this.uploadedFile = updatedFile;
      this.isUploading = false;

      // Notify parent if needed
      if (this.args.onFileChange) {
        this.args.onFileChange(updatedFile);
      }
    } catch (error) {
      console.error('Upload error:', error);
      this.errorMessage = `Failed to upload ${file.name}: ${error.message}`;
      setTimeout(() => {
        this.errorMessage = '';
      }, 700);
      this.uploadedFile = null;
      this.isUploading = false;
    }
  }

  @action
  removeFile() {
    if (this.isUploading) return;

    // If it's an existed file from server, call the API
    if (this.args.existedFile) {
      if (this.args.onRemoveExistedFile) {
        this.args.onRemoveExistedFile(this.args.existedFile);
      }
    } else {
      // Local uploaded file - just clear it
      this.uploadedFile = null;
      if (this.args.onFileChange) {
        this.args.onFileChange(null);
      }
    }
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
    <div class="inline-flex items-center gap-2">

      {{#if this.hasFile}}
        <!-- FILE PREVIEW POPOVER -->
        <div class="relative group">
          <!-- File Icon Button -->
          <button
            type="button"
            disabled={{this.currentFile.isUploading}}
            class="inline-flex items-center justify-center w-9 h-9 text-blue-600 bg-blue-50 border border-blue-200 rounded-lg hover:bg-blue-100 transition
              {{if this.currentFile.isUploading 'opacity-50 cursor-not-allowed'}}"
            title="View attached file"
          >
            {{#if this.currentFile.isUploading}}
              <!-- LOADING SPINNER -->
              <svg class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                <circle
                  class="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  stroke-width="4"
                ></circle>
                <path
                  class="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                ></path>
              </svg>
            {{else if this.shouldShowImageIcon}}
              <!-- IMAGE ICON -->
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                ></path>
              </svg>
            {{else}}
              <!-- PDF ICON -->
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M7 21h10a2 2 0 002-2V9.4a1 1 0 00-.3-.7L13.3 3.3A1 1 0 0012.6 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                ></path>
              </svg>
            {{/if}}
          </button>

          <!-- Hover Preview Card -->
          <div
            class="absolute bottom-full right-0 invisible group-hover:visible opacity-0 group-hover:opacity-100 transition-opacity z-50"
          >
            <div class="bg-white border-2 border-gray-300 rounded-lg shadow-lg p-3 w-64">
              <div class="flex items-start gap-3">
                <!-- Preview -->
                <div class="flex-shrink-0">
                  {{#if this.currentFile.preview}}
                    <img
                      src={{this.currentFile.preview}}
                      alt={{this.currentFile.name}}
                      class="w-12 h-12 rounded object-cover border border-gray-200"
                    />
                  {{else if this.currentFile.url}}
                    <img
                      src={{this.currentFile.url}}
                      alt={{this.currentFile.name}}
                      class="w-12 h-12 rounded object-cover border border-gray-200"
                    />
                  {{else}}
                    <div class="w-12 h-12 flex items-center justify-center bg-gray-100 rounded">
                      <svg
                        class="w-6 h-6 text-gray-600"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M7 21h10a2 2 0 002-2V9.4a1 1 0 00-.3-.7L13.3 3.3A1 1 0 0012.6 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                        ></path>
                      </svg>
                    </div>
                  {{/if}}
                </div>

                <!-- File Info -->
                <div class="flex-1 min-w-0">
                  <p
                    class="text-xs font-medium text-gray-900 truncate"
                  >{{this.currentFile.name}}</p>
                  {{#if this.currentFile.size}}
                    <p class="text-xs text-gray-500">{{this.currentFile.size}}</p>
                  {{/if}}
                  {{#if this.currentFile.isUploading}}
                    <p class="text-xs text-blue-600 font-medium">Uploading...</p>
                  {{/if}}
                </div>
              </div>

              <!-- Remove Button -->
              {{#unless this.currentFile.isUploading}}
                <button
                  type="button"
                  {{on "click" this.removeFile}}
                  class="mt-2 w-full px-2 py-1 text-xs font-medium text-red-600 bg-red-50 hover:bg-red-100 rounded transition"
                >
                  Remove File
                </button>
              {{/unless}}
            </div>
          </div>
        </div>

      {{else}}
        <!-- UPLOAD BUTTON (+ Icon) -->
        <label
          class="inline-flex items-center justify-center w-9 h-9 text-gray-600 bg-gray-100 border border-gray-300 rounded-lg cursor-pointer hover:bg-gray-200 transition
            {{if this.isDisabled 'opacity-50 cursor-not-allowed pointer-events-none'}}"
          title="Attach file"
        >
          <input
            type="file"
            accept={{this.acceptedFormats}}
            {{on "change" this.handleFileSelect}}
            disabled={{this.isDisabled}}
            class="hidden"
          />
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 4v16m8-8H4"
            ></path>
          </svg>
        </label>
      {{/if}}

      <!-- ERROR MESSAGE (Positioned absolutely or in a tooltip) -->
      {{#if this.errorMessage}}
        <div
          class="absolute top-full left-0 mt-1 p-2 bg-red-50 border border-red-200 rounded text-xs text-red-600 shadow-lg z-50 max-w-xs"
        >
          {{this.errorMessage}}
        </div>
      {{/if}}

    </div>
  </template>
}
