// FIXME once dart2js is updated with proper interop support
// This abstraction layer is necessary to ensure the proper object gets passed to the jss library


if (window['jss'] == undefined) console.warn("WARN: jss was not overridden");
else {
    window['jss_pure'] = window['jss'];
    window['jss'] = {
        set: function(selector, obj) {
            if (obj['CANARY'] === undefined) {
                for (var key in obj) {
                    if (obj.hasOwnProperty(key) && obj[key]['CANARY'] !== undefined) {
                        console.log('Found CANARY key in jss bridge!');
                        obj = obj[key];
                        break;
                    }
                }
            }
            delete obj['CANARY'];
            jss_pure.set(selector, obj);
        }
    };
}

