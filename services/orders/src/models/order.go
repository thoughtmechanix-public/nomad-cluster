package models

type Order struct {
	Id         string     `json:"Id"`
	Name       string     `json:"Name"`
	Currency   string     `json:"Currency"`
	TaxAmount  float32    `json:"TaxAmount"`
	GrandTotal float32    `json:"GrandTotal"`
	LineItems  []LineItem `json:"LineItems"`
}

type LineItem struct {
	Sku         string  `json:"SKU"`
	Name        string  `json:"Name"`
	Description string  `json:"Description"`
	UnitPrice   float32 `json:"UnitPrice"`
	Quantity    int32   `json:"Quanity"`
}
