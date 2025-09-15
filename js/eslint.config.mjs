// https://eslint.org/docs/latest/use/configure/configuration-files-new
// json-config-generator: https://eslint.org/play/


// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import/with
import globals from './dev/node_modules/globals/globals.json' with { type : 'json' }

import recommended from './dev/node_modules/@eslint/js/src/configs/eslint-recommended.js'


export default [
    recommended,

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
        },

	ignores : [
	    'dev',
        ],
    },
]
