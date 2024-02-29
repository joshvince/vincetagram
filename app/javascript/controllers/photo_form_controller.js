import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['imageInput', 'videoInput', 'imagePreview', 'videoPreview', 'submitBar'];

  handleImageSelection () {
    const [file] = this.imageInputTarget.files;

    if (!file) { return }

    this.imagePreviewTarget.src = URL.createObjectURL(file);
    this.imagePreviewTarget.classList.remove('w-0', 'h-0');
    this.imagePreviewTarget.classList.add('w-full');

    this.hideInputAndShowSubmit()
  }

  handleVideoSelection () {
    const [file] = this.videoInputTarget.files;

    if (!file) { return }
    if (file.size > 50097152) {
      alert('The file is too large')
      return
    }

    this.videoPreviewTarget.src = URL.createObjectURL(file);
    this.videoPreviewTarget.classList.remove('w-0', 'h-0', 'hidden');
    this.videoPreviewTarget.classList.add('h-full');

    this.hideInputAndShowSubmit()
  }

  hideInputAndShowSubmit () {
    this.imageInputTarget.parentNode.classList.add('hidden');
    this.videoInputTarget.parentNode.classList.add('hidden');
    this.submitBarTarget.classList.remove('hidden');
    this.submitBarTarget.classList.add('flex', 'flex-col');
  }
}
