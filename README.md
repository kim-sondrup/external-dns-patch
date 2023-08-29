# external-dns TidyDNS patch tool

Tool used to patch releases from [github.com/kubernetes-sigs/external-dns](https://github.com/kubernetes-sigs/external-dns) to support Netic's TidyDNS

```bash
./patch.sh '<path to external-dns source>'
cd '<path to external-dns source>'
git add .
git commit -m 'Added TidyDNS patch to <VERSION>'
```
