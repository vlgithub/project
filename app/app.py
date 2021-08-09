import consul
import flask
from flask import Flask, request, render_template


def validate_input(a, k, v):
    if a == "get" and k == "":
        return "Please set \"Key\" for the \"Get\" operation"
    elif a == "update" and ( k == "" or v == "" ):
        return "Please set \"Key\" for the \"Insert/Update\" operations"
    else:
        return "valid"

def get_value(k,c):
    index = None
    index, data = c.kv.get(k, index=index)
    try:
        return data['Value'].decode("utf-8")
    except TypeError:
        return "notFound"

def update_value(k,v,c):
    return c.kv.put(k, v)

app = Flask(__name__)

@app.route('/')
def my_form():
    return render_template('index.html')

@app.route('/process_input', methods=['POST'])
def process_input():
    k = request.form['key']
    v = request.form['value']
    a = request.form['action']
     
    check = validate_input(a, k, v)
    if check != "valid":
        return check
    
    c = consul.Consul(host='host.docker.internal')
    if a == "get":
        result = get_value(k,c)
        if result == "notFound":
            return "Not found. The KV pair does not exist"
        else:
            return "Key \"" + k + "\" has value: \"" + result + "\""
    else:
        result = update_value(k,v,c)
        if result:
            return "Success"
        else:
            return "Operation failed"

@app.route('/favicon.ico')
def favicon():
    return render_template('favicon.html')
