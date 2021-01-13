using System;
using Xunit;
using DemoAPI.Controllers;

namespace DemoAPI.Tests
{
    public class UnitTest1
    {
        ValuesController controller = new ValuesController();
        [Fact]
        public void VerifyReturnValue()
        {
            var returnValue = controller.Get(1); //test
            Assert.Equal("Yirgat", returnValue.Value);

        }
    }
}
