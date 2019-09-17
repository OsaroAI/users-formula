#!pydsl

pillar = __pillar__

conf = dict()
conf.update(pillar['pypi'])

def S(name, *args, **kwargs):
    name = '%s: %s' % (__name__, name)
    return state(name, *args, **kwargs)

for name, user in pillar.get('users', {}).items():
    if user == None:
        continue
    home = "/home/%s" % name
    manage = manage = user.get('manage_bashrc', False)
    bashrc_path = '%s/.bashrc' % home
    if manage:
        s1 = S('manage %s bashrc' % name) 
        s1.file.blockreplace(
            bashrc_path,
            source='salt://users/files/bashrc',
            marker_start='# START osaro managed bashrc zone',
            marker_end='# END osaro managed bashrc zone',
            append_if_not_found='True',
            context=conf,
            template='jinja'
        )
