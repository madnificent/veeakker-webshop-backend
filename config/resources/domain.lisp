(in-package :mu-cl-resources)

(define-resource organization ()
  :class (s-prefix "schema:Organization")
  :has-many `((delivery-place :via ,(s-prefix "schema:hasPos")
                              :as "delivery-places"))
  :resource-base (s-url "http://veeakker.be/organizations/")
  :on-path "organizations")

(define-resource delivery-place ()
  :class (s-prefix "veeakker:DeliveryPlace")
  :has-one `((delivery-kind :via ,(s-prefix "veeakker:hasDeliveryKind")
                            :as "delivery-kind")
             (geo-coordinate :via ,(s-prefix "schema:geo")
                             :as "geo-coordinate")
             (postal-address :via ,(s-prefix "schema:hasAddress")
                             :as "postal-address"))
  :resource-base (s-url "http://veeakker.be/delivery-places/")
  :on-path "delivery-places")

(define-resource delivery-kind ()
  :class (s-prefix "veeakker:DeliveryKind")
  :properties `((:label :string ,(s-prefix "skos:prefLabel"))
                (:description :string ,(s-prefix "dct:description")))
  :has-many `((delivery-place :via ,(s-prefix "veeakker:hasDeliveryKind")
                              :inverse t
                              :as "delivery-places"))
  :resource-base (s-url "http://veeakker.be/delivery-kinds/")
  :features '(include-uri)
  :on-path "delivery-kinds")

(define-resource geo-coordinate ()
  :class (s-prefix "schema:GeoCoordinate")
  :properties `((:latitude :number ,(s-prefix "schema:latitude"))
                (:longitude :number ,(s-prefix "schema:longitude")))
  :has-one `((postal-address :via ,(s-prefix "schema:address")
                             :as "postal-address"))
  :resource-base (s-url "http://veeakker.be/geo-coordinates/")
  :on-path "geo-coordinates")

(define-resource postal-address ()
  :class (s-prefix "schema:PostalAddress")
  :properties `((:country :string ,(s-prefix "schema:addressCountry"))
                (:locality :string ,(s-prefix "schema:addressLocality"))
                (:postal-code :string ,(s-prefix "schema:postalCode"))
                (:street-address :string ,(s-prefix "schema:streetAddress")))
  :resource-base (s-url "http://veeakker.be/postal-addresses/")
  :on-path "postal-addresses")

(define-resource product-group ()
  :class (s-prefix "veeakker:ProductGroup")
  :properties `((:label :string ,(s-prefix "skos:prefLabel"))
                (:sort-index :number ,(s-prefix "veeakker:sortIndex")))
  :has-one `((product-group :via ,(s-prefix "skos:broader")
                            :as "parent-group"))
  :has-many `((product-group :via ,(s-prefix "skos:broader")
                             :inverse t
                             :as "child-groups")
              (product :via ,(s-prefix "veeakker:hasProduct")
                       :as "products")
              (spotlight-product :via ,(s-prefix "veeakker:hasSpotlight")
                                 :as "spotlight-products"))
  :resource-base (s-url "http://veeakker.be/product-groups/")
  :on-path "product-groups")

(define-resource product ()
  :class (s-prefix "schema:Product")
  :properties `((:label :string ,(s-prefix "dct:title"))
                (:sort-index :number ,(s-prefix "veeakker:sortIndex")))
  :has-many `((product-group :via ,(s-prefix "veeakker:hasProduct")
                             :inverse t
                             :as "product-groups"))
  :resource-base (s-url "http://veeakker.be/products/")
  :on-path "products")

(define-resource spotlight-product ()
  :class (s-prefix "veeakker:SpotlightProduct")
  :properties `((:sort-index :number ,(s-prefix "veeakker:sortIndex")))
  :has-one `((product :via ,(s-prefix "veeakker:promotesProduct")
                      :as "product"))
  :has-many `((product-group :via ,(s-prefix "veeakker:hasSpotlight")
                             :inverse t
                             :as "product-groups"))
  :resource-base (s-url "https://veeakker.be/spotlight-products/")
  :on-path "spotlight-products")
