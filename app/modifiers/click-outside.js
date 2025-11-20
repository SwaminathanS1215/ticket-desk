// app/modifiers/click-outside.js (Simplified & Corrected)
import { modifier } from 'ember-modifier';

export default modifier(
  (element, [callback], { event = 'click', condition = true }) => {
    if (!condition) {
      return;
    }

    const listener = (event) => {
      // 1. Check if the clicked element is inside the element the modifier is applied to
      if (element.contains(event.target)) {
        return; // Click is inside the current dropdown, so do nothing.
      }

      // 2. If the click is outside, call the callback (i.e., close the dropdown)
      callback(event);
    };

    document.addEventListener(event, listener);

    return () => {
      document.removeEventListener(event, listener);
    };
  }
);
