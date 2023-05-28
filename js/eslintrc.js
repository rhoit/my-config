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

        // Suggestions
        'complexity'                  : ['error', 20],  // default:20
        'func-name-matching'          : ['error', 'always'],
        'func-style'                  : ['error', 'declaration', { allowArrowFunctions : false }],
        'max-depth'                   : ['error', 5],
        'max-lines'                   : ['error', { max : 999, skipBlankLines : true, skipComments : true }],
        'max-lines-per-function'      : ['error', { max : 256, skipBlankLines : true, skipComments : true }],
        'no-console'                  : 'error',
        'no-eval'                     : 'error',
        'no-restricted-syntax'        : ['error', 'ArrowFunctionExpression'],
        'no-var'                      : 'error',
        'one-var'                     : ['error', 'never'],
        'quote-props'                 : ['error', 'consistent'],
        'spaced-comment'              : ['error', 'always'],
        'yoda'                        : ['error', 'always'],

        // Layout & Formatting
        'block-spacing'               : ['error', 'always'],
        'brace-style'                 : ['error', '1tbs', { allowSingleLine : true }],
        'comma-dangle'                : ['error', 'always-multiline'],
        'comma-spacing'               : ['error', { before : false, after : true }],
        'computed-property-spacing'   : ['error', 'never'],
        'eol-last'                    : ['error', 'always'],
        'func-call-spacing'           : ['error', 'never'],
        'indent'                      : ['error', 4, { SwitchCase : 1 }],
        'keyword-spacing'             : ['error', { before : true, after : true }],
        'linebreak-style'             : ['error', 'unix'],
        'lines-between-class-members' : ['error', 'always', { exceptAfterSingleLine : true }],
        'max-len'                     : ['error', { code : 120, ignoreTrailingComments : true, ignoreStrings : true }],
        'no-multiple-empty-lines'     : ['error', { max : 2, maxEOF : 0, maxBOF : 1 }],
        'no-tabs'                     : ['error', { allowIndentationTabs: false }],
        'no-trailing-spaces'          : 'error',
        'quotes'                      : ['error', 'single', 'avoid-escape'],
        'semi'                        : ['error', 'never'],
        'space-before-blocks'         : ['error', { functions : 'always', keywords : 'always', classes : 'always' }],
        'space-in-parens'             : ['error', 'never'],
        'template-curly-spacing'      : ['error', 'never'],
    },
}
