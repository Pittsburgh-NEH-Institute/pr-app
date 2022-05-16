"use strict";
/*
 * Manage faceted search interface for pr-app
 * Indeterminate checkbox state: https://css-tricks.com/indeterminate-checkboxes/
 *  masks checked or unchecked status, so always set or clear explicitly
 */

document.addEventListener('DOMContentLoaded', (e) => {
    /* Attach event listeners to decades and month-years (not publishers) */
    var decades = document.querySelectorAll('#search-widgets summary > input');
    for (var i = 0, length = decades.length; i < length; i++) {
        decades[i].addEventListener('change', process_decade_check, false);
    }
    var years = document.querySelectorAll('#search-widgets details > ul > li > input');
    for (var i = 0, length = years.length; i < length; i++) {
        years[i].addEventListener('change', process_month_year_check, false);
    }
},
false);
/*
 * Manage accordion for dates
 */
function process_decade_check() {
    /* 
    * Toggle accordion and month-year children when summary is checked or unchecked 
    * Clear indeterminate status last, since children may set it 
    */
    if (this.checked) { // We just checked it
        /* Open accordion; check all children */
        this.parentElement.parentElement.setAttribute('open', '');
        var month_years = this.parentNode.nextElementSibling.getElementsByTagName('li');
        for (var i = 0, length = month_years.length; i < length; i++) {
            console.log(month_years[i].firstElementChild);
            month_years[i].firstElementChild.checked = true;
        }
    } else { // We just unchecked it
        /* Uncheck all children, leave accordion open */
        // this.parentElement.parentElement.removeAttribute('open');
        clear_checked_children(this);
    }
    this.indeterminate = false;
}
function process_month_year_check() {
    /*
    * Current status of this doesn't matter; check status of all siblings
    * Check parent decade when all child years are checked
    * Set to intermediate when some are checked
    */
    var decade_checkbox = this.parentElement.parentElement.parentElement.querySelector('summary > input');
    var all_siblings_checked = 
        this.parentElement.parentElement.querySelectorAll('input').length == this.parentElement.parentElement.querySelectorAll('input:checked').length;
    if (all_siblings_checked) { // All checked, so check decade
        decade_checkbox.checked = true;
        decade_checkbox.indeterminate = false;
    } else if (this.parentElement.parentElement.querySelectorAll('input:checked').length > 0) { // Some checked
        decade_checkbox.checked = false;
        decade_checkbox.indeterminate = true;
    } else { // None checked
        decade_checkbox.checked = false;
        decade_checkbox.indeterminate = false;
    }
}
function clear_checked_children(target) {
    /*
    * Clear all checked children
    * Fire click event to clear instead of just unchecking:
    * https://stackoverflow.com/questions/8206565/check-uncheck-checkbox-with-javascript
    */
    var children = target.parentElement.parentElement.querySelectorAll('input');
    for (var i = 0, length = children.length; i < length; i++) {
        children[i].checked = false;
    }
}