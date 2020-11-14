#!pydsl

pillar = __pillar__

conf = dict()
conf.update(pillar['pypi'])

for name, user in pillar.get('users', {}).items():
   current = salt.user.info(name)
   if user == None:
       user = {}
   home = user.get('home', current.get('home', "/home/%s" % name))
   manage = manage = user.get('manage_bashrc', False)
   if manage:
       s1.file.blockreplace(
           {{ home }}/.bashrc,
           source='salt://users/files/bashrc',
           marker_start='# START osaro managed bashrc zone',
           marker_end='# END osaro managed bashrc zone',
           append_if_not_found='True',
           context=conf,
           template='jinja'
       )
