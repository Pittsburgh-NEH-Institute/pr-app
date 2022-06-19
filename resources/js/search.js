"use strict";
/*
 * Manage faceted search interface for pr-app
 * Indeterminate checkbox state: https://css-tricks.com/indeterminate-checkboxes/
 *  masks checked or unchecked status, so always set or clear explicitly
 */

document.addEventListener('DOMContentLoaded', (e) => {
    /* Attach event listeners to decades and month-years (not publishers) */
    /* Set indeterminate state for decade if only some month-years are checked */
    var decades = document.getElementsByClassName('decade-checkbox');
    // console.log("in init: decades = " + decades + "(count: " + decades.length + ")");
    for (var i = 0, length = decades.length; i < length; i++) {
        decades[i].addEventListener('change', process_decade_check, false);
        var all_children = decades[i].closest('summary').nextElementSibling.querySelectorAll('input');
        // console.log("all_children = " + all_children + " (" + all_children.length + ")");
        var checked_children = decades[i].closest('summary').nextElementSibling.querySelectorAll('input:checked');
        // console.log("checked_children = " + checked_children + " (" + checked_children.length + ")");
        if (0 < checked_children.length && checked_children.length < all_children.length) { // set intermediate if some but not all children are checked
            decades[i].indeterminate = true;
        }
        if (0 < checked_children.length) { // open if any children are checked
            // decades[i].parentElement.parentElement.parentElement.setAttribute('open', '');
            decades[i].closest('details').setAttribute('open', '');
        }
        if (checked_children.length == all_children.length) {
            decades[i].checked = true;
        }
    }
    var month_years = document.querySelectorAll('#search-panel details > ul > li input');
    // console.log("in init: month+years = " + month_years + " (" + month_years.length + ")");
    for (var i = 0, length = month_years.length; i < length; i++) {
        month_years[i].addEventListener('change', process_month_year_check, false);
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
    // console.log("in process_decade_check: this = " + this);
    if (this.checked) { // We just checked it
        /* Open accordion; check all children */
        this.closest('details').setAttribute('open', '');
        var month_years = this.closest('summary').nextElementSibling.getElementsByTagName('li');
        for (var i = 0, length = month_years.length; i < length; i++) {
            month_years[i].firstElementChild.firstElementChild.checked = true;
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
    * Check ancestor decade when all child years are checked
    * Set to intermediate when some are checked
    */
    var decade_checkbox = this.closest('details').querySelector('summary input');
    var all_siblings_checked = 
        this.closest('ul').querySelectorAll('input').length == this.closest('ul').querySelectorAll('input:checked').length;
    if (all_siblings_checked) { // All checked, so check decade
        decade_checkbox.checked = true;
        decade_checkbox.indeterminate = false;
    } else if (this.parentElement.parentElement.parentElement.querySelectorAll('input:checked').length > 0) { // Some checked
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
    var children = target.parentElement.parentElement.parentElement.querySelectorAll('input');
    for (var i = 0, length = children.length; i < length; i++) {
        children[i].checked = false;
    }
}