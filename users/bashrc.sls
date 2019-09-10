#!pydsl

pillar = __pillar__

conf = dict()
conf.update(pillar['aws'])
conf.update(pillar['pypi'])

{% for name, user in pillar.get('users', {}).items() if user.absent is not defined or not user.absent %}
{%- set current = salt.user.info(name) -%}
{%- if user == None -%}
{%- set user = {} -%}
{%- endif -%}
{%- set home = user.get('home', current.get('home', "/home/%s" % name)) -%}
{%- set manage = user.get('manage_bashrc', False) -%}
{%- if manage -%}
s1 = state('user %s bashrc' % name)
s1.file.blockreplace(
    {{ home }}/.bashrc,
    source='salt://users/files/bashrc',
    marker_start='# START osaro managed bashrc zone',
    marker_end='# END osaro managed bashrc zone',
    append_if_not_found='True',
    context=conf,
    template='jinja'
)
{% endif %}
{% endfor %}
