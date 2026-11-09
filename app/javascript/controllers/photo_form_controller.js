import { Controller } from '@hotwired/stimulus'

const MAX_VIDEO_BYTES = 80_000_000

export default class extends Controller {
  static targets = ['imageInput', 'videoInput', 'chooser', 'preview', 'image', 'video', 'submitBar', 'error']

  showImage () {
    const [file] = this.imageInputTarget.files
    if (!file) return

    this.videoInputTarget.value = ''
    this.imageTarget.src = URL.createObjectURL(file)
    this.imageTarget.hidden = false
    this.videoTarget.hidden = true
    this.showPreview()
  }

  showVideo () {
    const [file] = this.videoInputTarget.files
    if (!file) return

    if (file.size > MAX_VIDEO_BYTES) {
      this.videoInputTarget.value = ''
      this.errorTarget.textContent = 'That video is over 80 MB. Try a shorter clip.'
      this.errorTarget.hidden = false
      return
    }

    this.imageInputTarget.value = ''
    this.videoTarget.src = URL.createObjectURL(file)
    this.videoTarget.hidden = false
    this.imageTarget.hidden = true
    this.showPreview()
  }

  reset () {
    this.imageInputTarget.value = ''
    this.videoInputTarget.value = ''
    this.previewTarget.hidden = true
    this.submitBarTarget.hidden = true
    this.chooserTarget.hidden = false
  }

  showPreview () {
    this.errorTarget.hidden = true
    this.chooserTarget.hidden = true
    this.previewTarget.hidden = false
    this.submitBarTarget.hidden = false
  }
}
