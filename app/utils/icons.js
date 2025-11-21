// app/utils/icons.js
import { htmlSafe } from '@ember/template';

// ⬇ 24x24 Heroicons Solid SVGs — reusable everywhere

export const HomeIcon = () =>
  htmlSafe(`
    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5"
      viewBox="0 0 20 20" fill="currentColor">
      <path d="M10.707 1.707a1 1 0 00-1.414 0l-8 8A1 1 0 002 11h1v6a1 1 
      0 001 1h4a1 1 0 001-1v-4h2v4a1 1 0 001 1h4a1 1 
      0 001-1v-6h1a1 1 0 00.707-1.707l-8-8z"/>
    </svg>
`);

export const TicketIcon = () =>
  htmlSafe(`
    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5"
      viewBox="0 0 24 24" fill="currentColor">
      <path d="M21 7V6a2 2 0 00-2-2h-3.586a1 1 0 
      01-.707-.293L12 1 9.293 3.707A1 1 0 
      018.586 4H5a2 2 0 00-2 2v1a2 2 0 
      000 4v6a2 2 0 002 2h14a2 2 0 
      002-2v-6a2 2 0 000-4z"/>
    </svg>
`);

export const BellIcon = () =>
  htmlSafe(`
    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6"
      viewBox="0 0 20 20" fill="currentColor">
      <path d="M10 2a6 6 0 00-6 6v2.586l-.707.707A1 
      1 0 004 13h12a1 1 0 00.707-1.707L16 
      10.586V8a6 6 0 00-6-6z"/>
      <path d="M10 18a3 3 0 002.995-2.824L13 
      15H7a3 3 0 002.824 2.995L10 18z"/>
    </svg>
`);

export const ChevronIcon = (collapsed = false) =>
  htmlSafe(`
    <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 transform
      ${collapsed ? 'rotate-180' : ''}" viewBox="0 0 20 20"
      fill="currentColor">
      <path fill-rule="evenodd"
        d="M12.79 4.21a1 1 0 010 1.42L9.41 
        9l3.38 3.38a1 1 0 
        01-1.42 1.42l-4.09-4.09a1 1 0 
        010-1.42l4.09-4.09a1 1 0 
        011.42 0z" clip-rule="evenodd"/>
    </svg>
`);

export const UserCircleIcon = () =>
  htmlSafe(`
    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6"
      viewBox="0 0 20 20" fill="currentColor">
      <path fill-rule="evenodd"
        d="M10 18a8 8 0 100-16 8 8 0 
        000 16zm0-9a2 2 0 
        110-4 2 2 0 
        010 4zm-4 5a4 4 0 
        118 0H6z"
        clip-rule="evenodd"/>
    </svg>
`);

export const MenuIcon = () => {
  return htmlSafe(`
    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6"
         fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
        d="M4 6h16M4 12h16M4 18h16" />
    </svg>
  `);
};

export const CreateIcon = () => {
  return htmlSafe(`  <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none"
       viewBox="0 0 24 24" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
          d="M12 4v16m8-8H4" />
  </svg>`);
};

export const TicketLargeIcon = () => {
  return htmlSafe(`  <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 text-blue-500" fill="none"
       viewBox="0 0 24 24" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8"
          d="M9 7h6m-6 4h6m-6 4h6M4 5h16v4a2 2 0 100 4v4H4v-4a2 2 0 100-4V5z"/>
  </svg>`);
};
