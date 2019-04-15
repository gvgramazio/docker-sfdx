# docker-sfdx
The main purpose of this image is to be as simple and to offer a starting point for setting up the CI/CD using GitLab Pipelines. Of course, it can also be used as-is to create and manage sfdx projects.

## Instructions
The following example the Salesforce CLI to manage the entire application development life cycle, including retrieve and deploy functionalities. However, a way to manage the authorization process is needed  because you are not there to personally log in when your CI job runs. In the following, is explained how to configure and use the OAuth JSON Web Token (JWT) bearer flow that’s supported in the Salesforce CLI.

You'll generate a private key for signing the JWT bearer token payload and you'll create a connected app in the org that contains a certificate generated from that private kwy.

The JWT bearer flow supports the RSA SHA256 algorithm, which uses an uploaded certificate as the signing secret. This OAuth flow gives you the ability to authenticate using the CLI without having to interactively log in. This headless flow is perfect for automated builds and scripting.

### Create a Self-Signed SSL Certificate and Private Key
Verify that you already have OpenSSL installed:

```
which openssl
```

If the command return a path that looked like `/usr/bin/openssl` then it's ok, otherwise install OpenSSL before proceding.

Create a certificates folder and enter it:

```
mkdir certificates
cd certificates
```

Generate an RSA private key:

```
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
```

Create a key file from the `server.pass.key` file:

```
openssl rsa -passin pass:x -in server.pass.key -out server.key
```

Delete the `server.pass.key` file:

```
rm server.pass.key
```

Request and generate the certificate:

```
openssl req -new -key server.key -out server.csr
```

Enter all requested information, but press Enter when prompted for the challenge password.

Generate the SSL certificate:

```
openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
```

The self-signed certificate is generated from the `server.key` private key and `server.csr` files.
The `server.crt` file is your site certificate, suitable for use with the connected app along with the `server.key` private key.

### Create the Connected App
- From Setup, enter `App Manager` in the Quick Find box, then select **App Manager**.
- Click New **Connected App**.
- Enter the connected app name and your email address:
  - Connected App Name: `sfdx gitlab ci`
  - Contact Email: `<your email address>`
- Select **Enable OAuth Settings**.
- Enter the callback URL: `http://localhost:1717/OauthRedirect`
- Select **Use digital signatures**.
- To upload your `server.crt` file, click **Choose File**.
- For OAuth scopes, add all available OAuth Scopes.
- Click **Save**.

After you've saved your connected app, edit the policies to enable the connected app to circumvent the manual login process.
- Click **Manage**.
- Click **Edit Policies**.
- In the OAuth policies section, for Permitted Users select **Admin approved users are pre-authorized**, then click **OK**.
- Click **Save**.

Lastly, create a permission set and assign pre-authorized users for this connected app.

- From Setup, enter `Permission` in the Quick Find box, then select `Permission Sets`.
- Click New.
- For the Label, enter: `sfdx gitlab ci`
- Click Save.
- Click **sfdx gitlab ci** | **Manage Assignments** | **Add Assignments**.
- Select the checkbox next to your system admin username, then click **Assign** | **Done**.
- Go back to your connected app.
  - From Setup, enter `App Manager` in the Quick Find box, then select **App Manager**.
  - Next to **sfdx gitlab ci**, click the list item drop-down arrow, then select **Manage**.
  - In the Permission Sets section, click **Manage Permission Sets**.
  - Select the checkbox next to **sfdx gitlab ci**, then click **Save**.