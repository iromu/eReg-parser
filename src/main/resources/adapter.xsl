<?xml version="1.0" encoding="ISO-8859-1" ?>

<!--   Copyright 2008 Ivan Rodriguez Murillo
	
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
	http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:payment="xalan://com.wantez.eregparser.util.Payment"
	xmlns:gln="xalan://com.wantez.eregparser.util.Gln"
	xmlns:country="xalan://com.wantez.eregparser.util.Country" version="1.0"
	xmlns:inv="urn:oasis:names:specification:ubl:schema:xsd:Invoice-1.0"
	xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnspecializedDatatypes-1.0"
	xmlns:sdt="urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-1.0"
	xmlns:cur="urn:oasis:names:specification:ubl:schema:xsd:CurrencyCode-1.0"
	xmlns:ccts="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-1.0"
	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-1.0"
	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-1.0"
	exclude-result-prefixes="inv udt sdt cur ccts cbc cac"
	extension-element-prefixes="date payment country gln">

	<xsl:output method="xml" indent="yes" encoding="ISO-8859-1" />

	<xsl:variable name="rootnode">ConjuntoDatosFacturas</xsl:variable>

	<xsl:variable name="quote">"</xsl:variable>

	<xsl:variable name="cdata-o">&lt;![CDATA[</xsl:variable>

	<xsl:variable name="cdata-c">]]&gt;</xsl:variable>

	<xsl:variable name="seller"
		select="/inv:Invoice/cac:SellerParty/cac:Party" />

	<xsl:variable name="buyer"
		select="/inv:Invoice/cac:BuyerParty/cac:Party" />

	<xsl:variable name="sellerCIF"
		select="normalize-space(translate($seller/cac:PartyIdentification/cac:ID[@identificationSchemeName='CIF/NIF'],' ',''))" />

	<xsl:variable name="buyerCIF"
		select="normalize-space(translate($buyer/cac:PartyIdentification/cac:ID[@identificationSchemeName='CIF/NIF'],' ',''))" />


	<xsl:template match="/">

		<ConjuntoDatosFacturas
			xsi:noNamespaceSchemaLocation="http://62.97.120.126/gfp/Remesa.xsd"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

			<Empresas>

				<xsl:for-each select="/inv:Invoice/*/cac:Party">

					<Empresa
						CIF="{normalize-space(translate(cac:PartyIdentification/cac:ID[@identificationSchemeName='CIF/NIF'],' ',''))}">
						<RSocial>
							<xsl:value-of disable-output-escaping="yes"
								select="concat($cdata-o,cac:PartyName/cbc:Name,$cdata-c)" />
						</RSocial>
						<Direccion>
							<xsl:value-of disable-output-escaping="yes"
								select="concat($cdata-o,cac:Address/cac:AddressLine/cbc:Line,$cdata-c)" />
						</Direccion>
						<CP>
							<xsl:value-of
								select="cac:Address/cbc:PostalZone" />
						</CP>
						<Localidad>
							<xsl:value-of disable-output-escaping="yes"
								select="concat($cdata-o,cac:Address/cbc:CountrySubentity,$cdata-c)" />
						</Localidad>
						<Provincia>
							<xsl:value-of disable-output-escaping="yes"
								select="concat($cdata-o,cac:Address/cbc:CityName,$cdata-c)" />
						</Provincia>
						<Pais>
							<xsl:value-of disable-output-escaping="yes"
								select="concat($cdata-o,country:parse(cac:Address/cac:Country/cbc:Name),$cdata-c)" />
						</Pais>
						<xsl:if
							test="seller/cac:Contact/cbc:Telephone">
							<Telefono>
								<xsl:value-of
									select="seller/cac:Contact/cbc:Telephone" />
							</Telefono>
						</xsl:if>
						<xsl:if test="cac:Contact/cbc:Telefax">
							<Fax>
								<xsl:value-of
									select="cac:Contact/cbc:Telefax" />
							</Fax>
						</xsl:if>
						<xsl:if
							test="normalize-space(cac:Contact/cbc:ElectronicMail)">
							<Email>
								<xsl:value-of
									select="normalize-space(cac:Contact/cbc:ElectronicMail)" />
							</Email>
						</xsl:if>
					</Empresa>
				</xsl:for-each>
			</Empresas>

			<xsl:variable name="invoiceId"
				select="normalize-space(/inv:Invoice/inv:ID)" />

			<xsl:variable name="taxInclusiveTotalAmount"
				select="normalize-space(/inv:Invoice/cac:LegalTotal/cbc:TaxInclusiveTotalAmount)" />

			<Facturas>

				<FacturaGeneral Plantilla="70" CIFEmisor="{$sellerCIF}"
					IdTipoFactura="FacturaComercial" IdTipoMoneda="EUR"
					ImporteTotal="{$taxInclusiveTotalAmount}" Nfactura="{$invoiceId}"
					CIFReceptor="{$buyerCIF}">

					<Cabecera>

						<xsl:variable name="invoiceDate"
							select="normalize-space(/inv:Invoice/cbc:IssueDate)" />

						<Fecha formato="yyyy-MM-dd">
							<xsl:value-of
								select="date:format-date($invoiceDate,'yyyy-MM-dd')" />
						</Fecha>

					</Cabecera>

					<xsl:variable name="gln"
						select="gln:parse(normalize-space(/inv:Invoice/cbc:Note))" />

					<IdentificacionEnvio>
						<GLN>
							<xsl:value-of select="$gln" />
						</GLN>
					</IdentificacionEnvio>

					<IdentificacionReceptor>
						<GLN>
							<xsl:value-of select="$gln" />
						</GLN>
					</IdentificacionReceptor>

					<Impuestos>

						<xsl:variable name="totalTaxAmount"
							select="normalize-space(/inv:Invoice/cac:TaxTotal/cbc:TotalTaxAmount)" />

						<xsl:for-each
							select="/inv:Invoice/cac:TaxTotal/cac:TaxSubTotal">

							<Impuesto>

								<BaseImponible>
									<xsl:value-of
										select="normalize-space(cbc:TaxableAmount)" />
								</BaseImponible>

								<TipoImpuesto>IVA</TipoImpuesto>

								<TasaImpuesto>
									<xsl:value-of
										select="normalize-space(cac:TaxCategory/cbc:Percent)" />
								</TasaImpuesto>

								<ImporteImpuesto>
									<xsl:value-of
										select="$totalTaxAmount" />
								</ImporteImpuesto>

							</Impuesto>

						</xsl:for-each>

					</Impuestos>

					<Vencimientos>

						<Vencimiento>
							<FormaPago>
								<xsl:value-of
									select="payment:parseMean(/inv:Invoice/cac:PaymentMeans/cac:Payment/cac:ID)" />
							</FormaPago>
							<FechaVencimiento formato="yyyy-MM-dd">
								<xsl:value-of
									select="date:format-date(/inv:Invoice/cac:PaymentTerms/cac:SettlementPeriod/cbc:EndDateTime,'yyyy-MM-dd')" />
							</FechaVencimiento>
						</Vencimiento>

					</Vencimientos>

					<Extensiones>

						<Extension nombre="TipoOperacion">
							<xsl:value-of disable-output-escaping="yes"
								select="concat($cdata-o,'Sujeta a IVA',$cdata-c)" />
						</Extension>

					</Extensiones>

					<TotalesFactura>

						<ImporteBruto>
							<xsl:value-of
								select="$taxInclusiveTotalAmount" />
						</ImporteBruto>

					</TotalesFactura>

					<xsl:variable name="documentReference"
						select="normalize-space(/inv:Invoice/inv:DespatchDocumentReference/cac:ID)" />

					<xsl:if test="$documentReference">

						<Albaranes>
							<Albaran id="{$documentReference}">

								<EntradaAlbaran nombre="id">
									<xsl:value-of
										disable-output-escaping="yes"
										select="concat($cdata-o,$documentReference,$cdata-c)" />
								</EntradaAlbaran>

							</Albaran>
						</Albaranes>

					</xsl:if>

					<Conceptos>

						<xsl:for-each
							select="/inv:Invoice/cac:InvoiceLine">

							<xsl:variable name="invoiceQty"
								select="normalize-space(cbc:InvoicedQuantity)" />

							<xsl:variable name="priceAmount"
								select="normalize-space(cac:Item/cac:BasePrice/cbc:PriceAmount)" />

							<xsl:variable name="priceTotal"
								select="cbc:LineExtensionAmount" />

							<Concepto>

								<Codigo>
									<xsl:value-of
										select="normalize-space(cac:Item/cac:StandardItemIdentification/cac:ID)" />
								</Codigo>

								<Cantidad>
									<xsl:value-of select="$invoiceQty" />
								</Cantidad>

								<Unidad>Unidades</Unidad>

								<Descripcion>
									<xsl:value-of
										disable-output-escaping="yes"
										select="concat($cdata-o,normalize-space(cac:Item/cbc:Description),$cdata-c)" />
								</Descripcion>

								<PUnitario>
									<xsl:value-of select="$priceAmount" />
								</PUnitario>

								<PUnitarioNeto>
									<xsl:value-of select="$priceAmount" />
								</PUnitarioNeto>

								<TotalNetoLinea>
									<xsl:value-of select="$priceTotal" />
								</TotalNetoLinea>

								<TotalBrutoLinea>
									<xsl:value-of select="$priceTotal" />
								</TotalBrutoLinea>

								<Impuestos>

									<Impuesto>

										<TipoImpuesto>IVA</TipoImpuesto>

										<TasaImpuesto>
											<xsl:value-of
												select="normalize-space(cac:Item/cac:TaxCategory/cbc:Percent)" />
										</TasaImpuesto>

									</Impuesto>

								</Impuestos>

							</Concepto>

						</xsl:for-each>

					</Conceptos>

				</FacturaGeneral>

			</Facturas>

		</ConjuntoDatosFacturas>

	</xsl:template>

</xsl:stylesheet>
