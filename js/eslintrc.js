// https://eslint.org/docs/latest/user-guide/configuring/configuration-files
// json-config-generator: https://eslint.org/play/


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
        sourceType  : 'module',
        ecmaVersion : 2018,
    },

    // https://eslint.org/docs/latest/rules/
    rules : {
    },
}
