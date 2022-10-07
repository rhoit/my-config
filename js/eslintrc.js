// https://eslint.org/docs/latest/user-guide/configuring/configuration-files
// json-config-generator: https://eslint.org/play/


module.exports = {
    extends : [
        // 'eslint:all',
        'eslint:recommended',
    ],

    env : {
        browser : true,
    },

    parserOptions : {
        sourceType  : 'module',
        ecmaVersion : 2018,
    },

    // https://eslint.org/docs/latest/rules/
    rules : {
    },
}
