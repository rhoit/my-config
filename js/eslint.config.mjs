// https://eslint.org/docs/latest/use/configure/configuration-files-new
// json-config-generator: https://eslint.org/play/


// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import/with
import globals from './dev/node_modules/globals/globals.json' with { type : 'json' }

import stylistic from './dev/node_modules/@stylistic/eslint-plugin/dist/index.js'
import recommended from './dev/node_modules/@eslint/js/src/configs/eslint-recommended.js'


export default [
    recommended,
    stylistic.configs.recommended,

    {
        languageOptions : {
            ecmaVersion : 2021,
            sourceType  : 'module',
            globals     : {
                // value compatibility false='readable' true='readonly'
                ...globals.browser,
            }
        },

        linterOptions : {
            reportUnusedDisableDirectives : 'error',
        },

        // https://eslint.org/docs/latest/rules/
        rules : {
            // Possible Problems
            'no-constant-condition'  : 'off',
            'no-duplicate-imports'   : ['error', { includeExports: true }],
            'no-self-compare'        : 'error',
            'no-unused-vars'         : ['error', { args: 'none' }],

            // Suggestions
            'complexity'             : ['error', 20],  // default:20
            'func-name-matching'     : ['error', 'always'],
            'func-style'             : ['error', 'declaration', { allowArrowFunctions: false }],
            'max-depth'              : ['error', 5],
            'max-lines'              : ['error', { max: 999, skipBlankLines: true, skipComments: true }],
            'max-lines-per-function' : ['error', { max: 256, skipBlankLines: true, skipComments: true }],
            'max-statements'         : ['error', { max: 25 }],  // default:20
            'no-console'             : ['error', { allow: ['info', 'warn', 'error'] }],
            'no-eval'                : 'error',
            'no-restricted-syntax'   : ['error', 'ArrowFunctionExpression'],
            'no-var'                 : 'error',
            'one-var'                : ['error', 'never'],
            'quote-props'            : ['error', 'consistent'],
            'yoda'                   : ['error', 'always'],

            // Layout & Formatting
            '@stylistic/array-bracket-spacing'       : ['error', 'never'],
            '@stylistic/block-spacing'               : ['error', 'always'],
            '@stylistic/brace-style'                 : ['error', '1tbs', { allowSingleLine: true }],
            '@stylistic/comma-dangle'                : ['error', 'always-multiline'],
            '@stylistic/comma-spacing'               : ['error', { before: false, after: true }],
            '@stylistic/computed-property-spacing'   : ['error', 'never'],
            '@stylistic/dot-location'                : ['error', 'object'],
            '@stylistic/eol-last'                    : ['error', 'always'],
            '@stylistic/function-call-spacing'       : ['error', 'never'],
            '@stylistic/indent'                      : ['error', 4, { SwitchCase: 1 }],
            '@stylistic/key-spacing'                 : ['error', { beforeColon : true, afterColon : true, mode : 'minimum', align : 'colon' }],
            '@stylistic/keyword-spacing'             : ['error', { before: true, after: true }],
            '@stylistic/linebreak-style'             : ['error', 'unix'],
            '@stylistic/lines-between-class-members' : ['error', 'always', { exceptAfterSingleLine: true }],
            '@stylistic/max-len'                     : ['error', { code: 120, ignoreTrailingComments: true, ignoreStrings: true }],
            '@stylistic/max-statements-per-line'     : ['error', { 'max' : 1, 'ignoredNodes': [ 'ReturnStatement'] }],
            '@stylistic/no-multi-spaces'             : ['error', { ignoreEOLComments : true, includeTabs : false, exceptions : { VariableDeclarator : true } }],
            '@stylistic/no-multiple-empty-lines'     : ['error', { max: 2, maxEOF: 0, maxBOF: 1 }],
            '@stylistic/no-tabs'                     : ['error', { allowIndentationTabs: false }],
            '@stylistic/no-trailing-spaces'          : 'error',
            '@stylistic/quotes'                      : ['error', 'single', {'avoidEscape' : true}],
            '@stylistic/semi'                        : ['error', 'never'],
            '@stylistic/space-before-blocks'         : ['error', { functions: 'always', keywords: 'always', classes: 'always' }],
            '@stylistic/space-in-parens'             : ['error', 'never'],
            '@stylistic/space-infix-ops'             : 'off',
            '@stylistic/spaced-comment'              : ['error', 'always'],
            '@stylistic/template-curly-spacing'      : ['error', 'never'],
        },

	ignores : [
	    'dev',
        ],
    },
]
