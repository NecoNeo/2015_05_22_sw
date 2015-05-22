<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<jsp:include page="inc.jsp"></jsp:include>

<script type="text/javascript">
var csHub = window.csHub = {
        init: function (origin) {
            this.originRule = origin;
        },
    
        get: function (key) {
            return JSON.stringify(window.localStorage.getItem(key));
        },
    
        set: function (key, value) {
            window.localStorage.setItem(key, JSON.stringify(value));
        },
    
        del: function (key) {
            window.localStorage.removeItem(key);
        }
    };
    
    window.addEventListener('message', function (event) {
        var message = JSON.parse(event.data), result, err = null;
        if (csHub.originRule.test(event.origin)) {
            try {
                result = csHub[message.method](message.key, message.value);
            }
            catch (e) {
                err = {
                    message: e.message,
                    stack: e.stack
                };
            }
            window.parent.postMessage(JSON.stringify({
                error: err,
                method: message.method,
                key: message.key,
                result: result
            }), event.origin);
        }
    }, false);

    csHub.init(new RegExp());
</script>
</head>
<body>
</body>
</html>