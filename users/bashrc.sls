#!pydsl

pillar = __pillar__

conf = dict()
conf.update(pillar['pypi'])

for name, user in pillar.get('users', {}).items():
   if user == None:
       continue
   home = "/home/%s" % name
   manage = manage = user.get('manage_bashrc', False)
   bashrc_path = '%s/.bashrc' % home
   if manage:
       s1.file.blockreplace(
           bashrc_path,
           source='salt://users/files/bashrc',
           marker_start='# START osaro managed bashrc zone',
           marker_end='# END osaro managed bashrc zone',
           append_if_not_found='True',
           context=conf,
           template='jinja'
       )
