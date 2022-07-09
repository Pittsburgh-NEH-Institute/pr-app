"use strict";
document.addEventListener('DOMContentLoaded', (e) => {
    var ghost_ref_pointers = document.getElementsByClassName('ghost-reference');
    for (var i = 0, length = ghost_ref_pointers.length; i < length; i++) {
        ghost_ref_pointers[i].addEventListener('change', toggle_ghost_ref, false);
    }
}, false);
function toggle_ghost_ref() {
    var targets = document.getElementsByClassName(this.id);
    if (this.checked) {
        for (var i = 0, length = targets.length; i < length; i++) {
            targets[i].classList.add('highlight');
        }
    } else {
        for (var i = 0, length = targets.length; i < length; i++) {
            targets[i].classList.remove('highlight');
        }
    }
}