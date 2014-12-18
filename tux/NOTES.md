upstream theblacktux {
  server 127.0.0.1:4000;
}

 location /static/admin/ {
    alias /home/ubuntu/environments/theblacktux/lib/python2.7/site-packages/django/contrib/admin/static/admin/;
    access_log off;
  }


