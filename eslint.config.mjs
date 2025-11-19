/**
 * ESLint Flat Config for Ember (JS + GJS)
 * ---------------------------------------
 * Fully compatible with:
 *  - Prettier
 *  - VS Code "format on save"
 *  - Ember Octane & Strict Mode
 *  - GJS Templates
 */

import globals from 'globals';
import js from '@eslint/js';

import ember from 'eslint-plugin-ember/recommended';
import eslintConfigPrettier from 'eslint-config-prettier';
import qunit from 'eslint-plugin-qunit';
import n from 'eslint-plugin-n';

import babelParser from '@babel/eslint-parser';

const esmParserOptions = {
  ecmaFeatures: { modules: true },
  ecmaVersion: 'latest',
  sourceType: 'module'
};

export default [
  /**
   * Base recommended rules
   */
  js.configs.recommended,

  /**
   * Disables conflicting styling rules (prettier handles formatting)
   */
  eslintConfigPrettier,

  /**
   * Ember plugin base + GJS support
   */
  ember.configs.base,
  ember.configs.gjs,

  /**
   * Files to ignore
   */
  {
    ignores: [
      'dist/',
      'node_modules/',
      'coverage/',
      '.embroider/',
      '!**/.*'
    ]
  },

  /**
   * Global linter options
   */
  {
    linterOptions: {
      reportUnusedDisableDirectives: 'error'
    }
  },

  /**
   * All JS/GJS files (App logic)
   */
  {
    files: ['**/*.{js,gjs}'],
    languageOptions: {
      parser: babelParser,
      parserOptions: esmParserOptions,
      globals: {
        ...globals.browser
      }
    }
  },

  /**
   * Test files
   */
  {
    files: ['tests/**/*-test.{js,gjs}'],
    plugins: { qunit },
    rules: qunit.configs.recommended.rules
  },

  /**
   * Node/CommonJS files
   */
  {
    files: [
      '**/*.cjs',
      'testem.js',
      'testem*.js',
      'ember-cli-build.js',
      'config/**/*.js'
    ],
    plugins: { n },
    languageOptions: {
      sourceType: 'script',
      ecmaVersion: 'latest',
      globals: {
        ...globals.node
      }
    },
    rules: n.configs['flat/recommended'].rules
  },

  /**
   * Node ESM Files
   */
  {
    files: ['**/*.mjs'],
    plugins: { n },
    languageOptions: {
      sourceType: 'module',
      parserOptions: esmParserOptions,
      globals: {
        ...globals.node
      }
    },
    rules: n.configs['flat/recommended-module'].rules
  }
];
