<?xml version="1.0" encoding="UTF-8"?>
<!-- =================================================== -->
<!-- XSL-FO stylesheet to generate Request in PDF format -->
<!-- =================================================== -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0"
        omit-xml-declaration="no" indent="yes" />

   
    <!-- ======================== -->
    <!-- root element: complaint -->
    <!-- ======================== -->
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master
                    master-name="letter" page-height="11.0in"
                    page-width="8.5in" margin-top="0.17in"
                    margin-bottom="0.17in" margin-left="1.0in"
                    margin-right="1.0in">
                    <fo:region-body margin-top="0.5in"
                        margin-bottom="0.5in" />
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="letter">

                <!-- output data goes here -->
                <fo:flow flow-name="xsl-region-body" font-family="'Lucida Grande',Tahoma,Arial,sans-serif">
					<xsl:apply-templates select="changeCaseFileState"/>
					<fo:block font-size="10pt" space-after="0.15in">
                        Change Case Status Information
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Change Date
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="changeCaseFileState/changeDate"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Case Number
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="changeCaseFileState/caseNumber"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Status
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="changeCaseFileState/status"/>
						</fo:block>
                    </fo:block>
					<xsl:value-of select="changeCaseFileState/showStatusResolution"/>
						<fo:block font-size="10pt" space-after="0.15in">
							Case Resolution
							<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
								<fo:table-body font-weight="normal" font-size="12pt">
									<fo:table-row line-height="12pt">
										<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:list-block>
												<fo:list-item>
												 <fo:list-item-label>
												   <fo:block margin-left="10mm" margin-top="1mm">
														<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="10%">
															<fo:table-body font-weight="normal" font-size="12pt">
																<xsl:for-each select="changeCaseFileState/participants">
																	<xsl:for-each select="participant">
																		<fo:table-row line-height="12pt" font-size="10pt">
																			<xsl:choose>
																				<xsl:when test="changeCaseFileState/statusResolution = '1'">
																					<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm" background-color="black">
																						<fo:block text-align="center"></fo:block>
																					</fo:table-cell>
																				</xsl:when>
																				<xsl:when test="changeCaseFileState/statusResolution = 1">
																					<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm" background-color="black">
																						<fo:block text-align="center">aaa</fo:block>
																					</fo:table-cell>
																				</xsl:when>
																				<xsl:otherwise>
																					<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
																						<fo:block text-align="center"></fo:block>
																					</fo:table-cell>
																				</xsl:otherwise>
																			</xsl:choose>
																		</fo:table-row>
																	</xsl:for-each>
																</xsl:for-each>
															</fo:table-body>
														</fo:table>
													</fo:block>
												 </fo:list-item-label>
												 <fo:list-item-body>
													<fo:block text-align="center">Denied</fo:block>
												 </fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
									    </fo:table-cell>
										<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:list-block>
												<fo:list-item>
												 <fo:list-item-label>
												   <fo:block margin-left="10mm" padding-top="1mm">
														<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="10%">
															<fo:table-body font-weight="normal" font-size="12pt">
																<xsl:for-each select="changeCaseFileState/participants">
																	<xsl:for-each select="participant">
																		<fo:table-row line-height="12pt" font-size="10pt">
																			<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
																				<fo:block text-align="center"></fo:block>
																			</fo:table-cell>
																		</fo:table-row>
																	</xsl:for-each>
																</xsl:for-each>
															</fo:table-body>
														</fo:table>
													</fo:block>
												 </fo:list-item-label>
												 <fo:list-item-body>
													<fo:block text-align="center">Full</fo:block>
												 </fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
									    </fo:table-cell>
										<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:list-block>
												<fo:list-item>
												 <fo:list-item-label>
												   <fo:block margin-left="10mm" padding-top="1mm">
														<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="10%">
															<fo:table-body font-weight="normal" font-size="12pt">
																<xsl:for-each select="changeCaseFileState/participants">
																	<xsl:for-each select="participant">
																		<fo:table-row line-height="12pt" font-size="10pt">
																			<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
																				<fo:block text-align="center"></fo:block>
																			</fo:table-cell>
																		</fo:table-row>
																	</xsl:for-each>
																</xsl:for-each>
															</fo:table-body>
														</fo:table>
													</fo:block>
												 </fo:list-item-label>
												 <fo:list-item-body>
													<fo:block text-align="center">Partial</fo:block>
												 </fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
									    </fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>

						</fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-body font-weight="normal" font-size="12pt">
								<fo:table-row line-height="12pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">Select Approver</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<xsl:for-each select="changeCaseFileState/participants">
									<xsl:for-each select="participant">
										<fo:table-row line-height="12pt" font-size="10pt">
											<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="participantName"/></fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:for-each>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
				   </fo:block>

                </fo:flow>
            </fo:page-sequence>

        </fo:root>
    </xsl:template>
</xsl:stylesheet>
