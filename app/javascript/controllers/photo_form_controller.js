import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['fileInput', 'imagePreview', 'submitBar'];

  handlePhotoSelection() {
    const [file] = this.fileInputTarget.files;

    if (file) {
      this.imagePreviewTarget.src = URL.createObjectURL(file);
      this.imagePreviewTarget.classList.remove('w-0', 'h-0');
      this.imagePreviewTarget.classList.add('w-full');
      this.fileInputTarget.classList.add('hidden');
      this.submitBarTarget.classList.remove('hidden');
      this.submitBarTarget.classList.add('flex', 'flex-col');
    }
  }
}
