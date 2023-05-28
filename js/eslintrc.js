// https://eslint.org/docs/latest/user-guide/configuring/configuration-files
// json-config-generator: https://eslint.org/play/


/* eslint-env node */

module.exports = {
    extends : [
        // 'eslint:all',
        'eslint:recommended',
    ],

    // https://eslint.org/docs/latest/use/configure/language-options
    env : {
        browser : true,
        es6     : true,  // for Promise
    },

    parserOptions : {
        sourceType : 'module',
        ecmaVersion : 2020,
        allowImportExportEverywhere : true,
    },

    // https://eslint.org/docs/latest/rules/
    rules : {
        // Possible Problems
        'no-constant-condition'       : 'off',
        'no-duplicate-imports'        : ['error', { includeExports : true }],
        'no-self-compare'             : 'error',
        'no-unused-vars'              : ['error', { args : 'none' }],  // recommended-override
    },
}
