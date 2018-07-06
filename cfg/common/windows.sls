common-windows-choco-bootstrap:
  module.run:
    - name: chocolatey.bootstrap

{% from 'choco.jinja' import installed, upgraded %}

{{ upgraded('chocolatey') }}

{{ installed('git') }}
{{ installed('sudo') }}
{{ installed('7zip') }}
