"use strict";
/* ***
 * Manage faceted search interface for pr-app
 * ***/

 /* ***
 * Attach event listeners
 * ***/
document.addEventListener('DOMContentLoaded', (e) => {
    /* Decade checkboxes listen for change of state */
    var decades = document.querySelectorAll('#search summary > input');
    for (var i = 0, length = decades.length; i < length; i++) {
        decades[i].addEventListener('change', toggle_details, false);
    }
    var years = document.querySelectorAll('#search details > ul > li > input');
    for (var i = 0, length = years.length; i < length; i++) {
        years[i].addEventListener('change', select_decade_from_year, false);
    }
},
false);
/* ***
 * Manage accordion
 * ***/
function toggle_details() {
    /* Toggle accordion when summary is checked or unchecked */
    if (this.checked) {
        /* Open accordion; children are not checked */
        this.parentElement.parentElement.setAttribute('open', '');
    } else {
        /* Uncheck all children and close accordion */
        this.parentElement.parentElement.removeAttribute('open');
        clear_checked_children(this);
    }
}
/* ***
 * Check parent decade when any child year is checked
 * ***/
function select_decade_from_year() {
    if (this.checked) {
        /* Check decade when checking year (harmlessly redundant if already checked)
         * Do not uncheck decade when unchecking year, since checked decade is allowed */
        var decade_checkbox = this.parentElement.parentElement.parentElement.querySelector('summary > input');
        if (decade_checkbox.checked == false) {
            decade_checkbox.click()
        };
    }
}

/* ***
 * Clear all checked children
 * Fire click event to clear instead of just unchecking:
 *  https://stackoverflow.com/questions/8206565/check-uncheck-checkbox-with-javascript
 * ***/
function clear_checked_children(target) {
    var children = target.parentElement.parentElement.querySelectorAll('input');
    for (var i = 0, length = children.length; i < length; i++) {
        if (children[i].checked == true) {
            children[i].click();
        }
    }
}