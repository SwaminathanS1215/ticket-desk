export default {
  /**
   * Global defaults
   * ---------------------------------------------
   * JS = single quotes
   * GJS/HBS = uses prettier-plugin-ember-template-tag
   */
  singleQuote: true,
  trailingComma: 'es5',
  printWidth: 100,

  /**
   * Required for <template> in GJS/GTS
   */
  plugins: ['prettier-plugin-ember-template-tag'],

  /**
   * Overrides per file type
   */
  overrides: [
    // JS / TS files
    {
      files: ['*.{js,ts,cjs,mjs,cts,mts}'],
      options: {
        singleQuote: true,
        trailingComma: 'es5'
      }
    },

    // HTML files
    {
      files: ['*.html'],
      options: {
        singleQuote: false
      }
    },

    // JSON
    {
      files: ['*.json'],
      options: {
        singleQuote: false
      }
    },

    // Ember classic HBS templates
    {
      files: ['*.hbs'],
      options: {
        singleQuote: false
      }
    },

    // GJS / GTS files (template-tag plugin)
    {
      files: ['*.{gjs,gts}'],
      options: {
        /**
         * For <template> inside .gjs
         */
        templateSingleQuote: false,
        trailingComma: 'es5'
      }
    }
  ]
};
