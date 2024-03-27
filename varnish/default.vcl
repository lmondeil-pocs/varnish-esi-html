# specify the VCL syntax version to use
vcl 4.1;

import dynamic;

# Définition des backends
backend default {
	.host = "main";
	.port = "80";
} 

backend header-footer {
	.host = "header-footer";
	.port = "80";
} 
backend products {
	.host = "products";
	.port = "80";
} 

backend social {
	.host = "social";
	.port = "80";
} 

# Ajout de headers pour le debug
sub vcl_deliver {
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
    } else {
        set resp.http.X-Cache = "MISS";
    }
    set resp.http.X-Cache-Hits = obj.hits;
    return (deliver);
}

# Activation des ESI
sub vcl_backend_response {
    set beresp.do_esi = true;
    set beresp.ttl = 5s;
}

# Routage spécifique
sub vcl_recv {
    if(req.http.host ~ "header-footer") { set req.backend_hint = header-footer; }    
    if(req.http.host ~ "products") { set req.backend_hint = products; }    
    if(req.http.host ~ "social") { set req.backend_hint = social; }  
}